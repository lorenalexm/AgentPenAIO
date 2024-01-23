import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

export function initializeFirebase(apiKey, authDomain, projectId, storageBucket, messagingSenderId, appId) {
	const firebaseConfig = {
		apiKey: apiKey,
		authDomain: authDomain,
		projectId: projectId,
		storageBucket: storageBucket,
		messagingSenderId: messagingSenderId,
		appId: appId
	};
	
	const app = initializeApp(firebaseConfig);
	const auth = getAuth(app);

	return [app, auth];
}
