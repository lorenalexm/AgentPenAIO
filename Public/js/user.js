import { onAuthStateChanged, signOut } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

/**
 * Ensures Firebase user is current, then fetches user data from server.
 * 
 * @param {object} auth The Firebase Auth object.
 * @returns {Promise<object, error>} The current user object.
 */
export function verifyAndGetUser(auth) {
	return new Promise((resolve, reject) => {
		onAuthStateChanged(auth, (user) => {
			if(!user) {
				reject("NOUSER");
			}

			user.getIdToken().then((token) => {
				fetch(`${window.location.origin}/api/user/`, {
					method: "GET",
					cache: "no-cache",
					headers: {
						"Authorization": `Bearer ${token}`
					}
				}).then((response) => {
					resolve(response);
				}).catch((error) => {
					reject(error);
				});
			});
		});
	});
}

/**
 * Attempts to signout the user and redirect to the home page.
 * 
 * @param {object} auth The Firebase Auth object.
 */
export function signout(auth) {
	signOut(auth).then(() => {
		window.location.assign(`${window.location.origin}/`);
	}).catch((error) => {
		console.error(error);
	});
}
