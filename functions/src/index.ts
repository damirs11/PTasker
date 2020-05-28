import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

// const db = admin.firestore();
const fcm = admin.messaging();

export const sendToTopic = functions.firestore
  .document("projects/{projectId}")
  .onCreate(async (snapshot) => {
    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: "New Project",
        body: `Project is ready`,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    return fcm.sendToTopic("onCreateProjectNotification", payload);
  });
