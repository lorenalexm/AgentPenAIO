import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

/**
 * Attempts to initialize the Firebase app and retrieves the Auth object.
 * 
 * @param {string} apiKey The Firebase API key.
 * @param {string} authDomain The Firebase authorized domain.
 * @param {string} projectId The Firebase project Id.
 * @param {string} storageBucket The Firebase storage bucket for the project.
 * @param {string} messagingSenderId The Firebase message sender Id.
 * @param {string} appId The Firebase application Id.
 * @returns {[object, object]} A touple containing the Firebase app and Auth objects.
 */
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
