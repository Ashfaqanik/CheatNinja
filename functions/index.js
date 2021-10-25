const functions = require("firebase-functions");
const admin =require('firebase-admin');

admin.initializeApp();
var db = admin.firestore();
var fcm = admin.messaging();

exports.notifyMessage = functions.firestore
    .document('Notifications/{NotificationId}')
    .onCreate(async snapshot => {
        const message = snapshot.data();

//        const querySnapshot = await db
//                    .collection('Token')
//                    .doc('tokenId')
//                    .collection('tokens')
//                    .get();
//
//        const tokens = querySnapshot.docs.map(snap=>snap.id);

           const payload = {
           notification: {
                           title: `${message.title}`,
                           body: message.message,
                           icon: 'ic_notification'
                       },
            data: {
                         title: `${message.title}`,
                         body: message.message,
                         click_action: 'FLUTTER_NOTIFICATION_CLICK',
                         sound: "default",
                         status: "done",
                         screen: 'OPEN_PAGE1',
                         extradata: "",
                       }
           }

        return fcm.sendToTopic('Notifications', payload);



    });


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
