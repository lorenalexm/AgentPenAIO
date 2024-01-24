import { signInWithPopup, GoogleAuthProvider, FacebookAuthProvider } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

/**
 * Creates a new button object that will sign the user in with Google.
 * 
 * @param {object} auth The Firebase Auth object.
 * @param {string} embedInID Optional DOM ID to embed button in.
 */
export function createGoogleLoginButton(auth, embedInID = "") {
	const provider = new GoogleAuthProvider();
	createButton("Sign in with Google", auth, provider, embedInID);
}

/**
 * Creates a new button object that will sign the user in with Facebook.
 * 
 * @param {object} auth The Firebase Auth object.
 * @param {string} embedInID Optional DOM ID to embed button in.
 */
export function createFacebookLoginButton(auth, embedInID = "") {
	const provider = new FacebookAuthProvider();
	createButton("Sign in with Facebook", auth, provider, embedInID);
}

/**
 * Creates a button object, adds click event, and appends to body or inner element.
 * 
 * @param {string} text The text within the button element.
 * @param {object} auth The Firebase Auth object.
 * @param {object} provider The Firebase Auth Provider object.
 * @param {string} embedInID Optional DOM ID to embed button in.
 */
function createButton(text, auth, provider, embedInID = "") {
	var button = document.createElement("button");
	button.textContent = text;
	button.addEventListener("click", () => {
		processSignIn(auth, provider);
	});

	if(embedInID !== "") {
		document.getElementById(embedInID).appendChild(button);
	} else {
		document.body.appendChild(button);
	}
}

/**
 * Processes the sign in attempt with Firebase using the given provider.
 * 
 * @param {object} auth The Firebase Auth object.
 * @param {object} provider The Firebase Auth Provider object.
 */
function processSignIn(auth, provider) {
	signInWithPopup(auth, provider).then((result) => {
		result.user.getIdToken().then((token) => {
			fetch(`${window.location.origin}/verify`, {
				method: "GET",
				cache: "no-cache",
				headers: {
					"Authorization": `Bearer ${token}`
				}
			}).then(() => {
				window.location.assign(`${window.location.origin}/me`);
			}).catch(() => {
				window.location.assign(`${window.location.origin}/authentication`);
			});
		}).catch(() => {
			window.location.assign(`${window.location.origin}/authentication`);
		});
	}).catch(() => {
		window.location.assign(`${window.location.origin}/auth`);
	});
}
