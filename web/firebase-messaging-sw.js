importScripts("https://www.gstatic.com/firebasejs/10.0.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.0.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyAp7VmGvH2RsG8s8UUYIM-yCaOeG86CPEM",
  authDomain: "syrian-hajj.firebaseapp.com",
  projectId: "syrian-hajj",
  storageBucket: "syrian-hajj.appspot.com",
  messagingSenderId: "242504343313",
  appId: "1:242504343313:web:763fe06d69da5593ea36b0",
  measurementId: "G-17VJVCKPV7"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function (payload) {
  const notificationTitle = payload.notification?.title ?? "إشعار جديد";
  const notificationOptions = {
    body: payload.notification?.body ?? "",
    icon: "/icons/Icon-192.png",
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});
