import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

export function createFirebaseUI(apiKey, authDomain, projectId, storageBucket, messagingSenderId, appId) {
	const firebaseConfig = {
		apiKey: apiKey,
		authDomain: authDomain,
		projectId: projectId,
		storageBucket: storageBucket,
		messagingSenderId: messagingSenderId,
		appId: appId
	};
	
	const app = initializeApp(firebaseConfig);
	const authInstance = getAuth(app);
	
	var uiConfig = {
		signInOptions: [
			firebase.auth.GoogleAuthProvider.PROVIDER_ID,
			firebase.auth.FacebookAuthProvider.PROVIDER_ID,
		],
		signInSuccessUrl: '/me',
		signInFlow: 'popup',
		tosUrl: '/tos',
		privacyPolicyUrl: '/privacy',
		callbacks: {
			signInSuccessWithAuthResult: function(authResult) {
				authResult.user.getIdToken().then((token) => {
					fetch(`${window.location.origin}/verify`, {
						method: "GET",
						cache: "no-cache",
						headers: {
							"Authorization": `Bearer ${token}`
						}
					}).then((response) => {
						console.log(response);
						window.location.assign(`${window.location.origin}/me`);
					}).catch((error) => {
						console.error(error);
						window.location.assign(`${window.location.origin}/auth`);
					});
				}).catch((error) => {
					console.error(error);
					window.location.assign(`${window.location.origin}/auth`);
				});
				
				return false;
			},
		},
	};
	
	const ui = new firebaseui.auth.AuthUI(authInstance);
	ui.start("#firebaseui-auth-container", uiConfig);
}
