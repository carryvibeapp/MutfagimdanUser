importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: 'AIzaSyCp4ZpzxIsU85k-_5M41cQczxOFUW_zrW8',
    appId: '1:460022449022:web:ddd07c4bb03de4ad83692f',
    messagingSenderId: '460022449022',
    projectId: 'carryvibe-efood',
    authDomain: 'carryvibe-efood.firebaseapp.com',
    storageBucket: 'carryvibe-efood.appspot.com',
    measurementId: 'G-3E7B3ZQ0CG',
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
});
