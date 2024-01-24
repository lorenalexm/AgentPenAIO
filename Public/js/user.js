import { onAuthStateChanged, signOut } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

/**
 * Verifies and returns the current user, or redirects to authentication page if none.
 * 
 * @param {object} auth The Firebase Auth object.
 * @returns {object} The current user object.
 */
export function verifyAndGetUser(auth) {
	onAuthStateChanged(auth, (user) => {
		if(!user) {
			window.location.assign(`${window.location.origin}/authentication`);
		}

		return user;
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
