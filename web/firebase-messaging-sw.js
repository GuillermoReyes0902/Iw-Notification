// web/firebase-messaging-sw.js
importScripts('https://www.gstatic.com/firebasejs/10.12.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.1/firebase-messaging-compat.js');

firebase.initializeApp({
    apiKey: 'AIzaSyA1lJkfibMjSWXjsfGSseEdktxS99KyUIg',
    appId: '1:721093293596:web:cac81b11a4cd9f140211d9',
    messagingSenderId: '721093293596',
    projectId: 'iw-reminder',
});

// Retrieve an instance of Firebase Messaging
const messaging = firebase.messaging();
