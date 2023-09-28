//
//  RequestService.swift
//
//
//  Created by Alex Loren on 9/28/23.
//

import Vapor

protocol RequestService {
    // MARK: - Functions
    func `for`(_ req: Request) -> Self
}
