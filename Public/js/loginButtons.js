import { signInWithPopup, GoogleAuthProvider, FacebookAuthProvider } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

export function createGoogleLoginButton(auth, embedInID = "") {
	const provider = new GoogleAuthProvider();
	createButton("Sign in with Google", auth, provider, embedInID);
}

export function createFacebookLoginButton(auth, embedInID = "") {
	const provider = new FacebookAuthProvider();
	createButton("Sign in with Facebook", auth, provider, embedInID);
}

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
				window.location.assign(`${window.location.origin}/auth`);
			});
		}).catch(() => {
			window.location.assign(`${window.location.origin}/auth`);
		});
	}).catch(() => {
		window.location.assign(`${window.location.origin}/auth`);
	});
}
