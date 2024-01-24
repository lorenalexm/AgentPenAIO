//
//  UserControllerTests.swift
//
//
//  Created by Alex Loren on 1/9/24.
//

@testable import App
import XCTVapor

final class UserControllerTests: XCTestCase {
    // MARK: - Properties
    var app: Application!
    var token: String?
    
    // MARK: - Functions
    
    /// Sets up the testing environment before each test.
    override func setUp() async throws {
        app = try await Application.testable()
        token = try await getOrReturnToken()
    }
    
    /// Tears down the testing environment before each test.
    override func tearDown() async throws {
        app.shutdown()
    }
    
    /// Attempts to get a new token, or return the cached token.
    /// - Returns: A Firebase user Id token.
    func getOrReturnToken() async throws -> String {
        guard let token else {
            self.token = try await getFirebaseToken()
            return token!
        }
        
        return token
    }
    
    /// Tests getting `User` without a Bearer token.
    func testGettingUserWithoutToken() async throws {
        try app.test(.GET, "/api/user/", afterResponse: { response in
            XCTAssertEqual(response.status, .badRequest)
        })
    }
    
    /// Tests getting a `User` that does not exist.
    func testGettingInvalidUser() async throws {
        try await app.test(.GET, "/api/user/", beforeRequest: { request in
            request.headers.bearerAuthorization = try await BearerAuthorization(token: getOrReturnToken())
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .notFound)
        })
    }
    
    /// Tests creating and getting a `UserDTO` object.
    func testGettingValidUser() async throws {
        try await app.test(.GET, "/api/user/verify", beforeRequest: { request in
            let count = try await app.repositories.users.count()
            XCTAssertEqual(count, 0)
            request.headers.bearerAuthorization = try await BearerAuthorization(token: getOrReturnToken())
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .created)
            let count = try await app.repositories.users.count()
            XCTAssertEqual(count, 1)
        })
        
        try await app.test(.GET, "/api/user", beforeRequest: { request in
            request.headers.bearerAuthorization = try await BearerAuthorization(token: getOrReturnToken())
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let user = try response.content.decode(UserDTO.self)
            XCTAssertEqual(user.fullName, "Dummy User")
            XCTAssertEqual(user.email, "dummy@account.email")
        })
    }
    
    /// Tests attempting verification of a `User` with no Bearer token.
    func testVerifyWithNoToken() async throws {
        try await app.test(.GET, "/api/user/verify", afterResponse: { response in
            XCTAssertEqual(response.status, .badRequest)
            let count = try await app.repositories.users.count()
            XCTAssertEqual(count, 0)
        })
    }
    
    /// Tests attempting verification of a new `User` with a Bearer token.
    func testVerifyNewUserWithToken() async throws {
        try await app.test(.GET, "/api/user/verify", beforeRequest: { request in
            let count = try await app.repositories.users.count()
            XCTAssertEqual(count, 0)
            request.headers.bearerAuthorization = try await BearerAuthorization(token: getOrReturnToken())
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .created)
            let count = try await app.repositories.users.count()
            XCTAssertEqual(count, 1)
        })
    }
    
    /// Tests attempting verification of an existing `User` with a Bearer token.
    func testVerifyExistingUserWithToken() async throws {
        try await app.test(.GET, "/api/user/verify", beforeRequest: { request in
            let count = try await app.repositories.users.count()
            XCTAssertEqual(count, 0)
            request.headers.bearerAuthorization = try await BearerAuthorization(token: getOrReturnToken())
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .created)
            let count = try await app.repositories.users.count()
            XCTAssertEqual(count, 1)
        })
        
        try await app.test(.GET, "/api/user/verify", beforeRequest: { request in
            request.headers.bearerAuthorization = try await BearerAuthorization(token: getOrReturnToken())
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let count = try await app.repositories.users.count()
            XCTAssertEqual(count, 1)
        })
    }
}
