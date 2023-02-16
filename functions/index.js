const admin = require("firebase-admin");
const functions = require("firebase-functions");

admin.initializeApp(functions.config().firebase);

// get the token of the device
async function getToken()  {
    var instance = await admin.firestore().collection('fcm').doc('token').get();
    let _token = instance.data()['token'];
    console.log(_token);

    return _token;
    }




// Send notification when new record are created.
exports.timeInNotification = functions.firestore.document('employee/{employeeId}/record/{recordId}').onCreate(async (event) => {

    // get the fcm token
    var token = await getToken();

    // get the name (the name field is same with the record field
    //var name = "" ;
    
    
    
    

    let body = "has time in";
    
    // time in message
    let timeIn = "Time in";
    
    var message = {
        notification: {
            title: timeIn,
            body: body
        },
        
    };

    // send the notification
    let response = await admin.messaging().sendToDevice(token,message);
    console.log(response);
});
 

// Send notification when the field inside record update.
exports.timeOutNotification = functions.firestore.document('employee/{employee}/record/{recordId}').onUpdate(async (event) => { 

    // get the fcm token
    var token = await getToken();


    
    // get the name (the name field is same with the record field)
    var name = ev;

    let body = name + " has time out";

    // time out message
    let timeOut = "Time out";

    // notification message
    var message = {
        notification: { 
            title: timeOut,
            body: body
        },
        

    }

    // send the notification message
    let response = await admin.messaging().sendToDevice(token,message);
    console.log(response);
});
 





// const messaging = admin.messaging();

// exports.notifySubscribers = functions.https.onCall(async (data, _) => {
//     try {
//         await messaging.sendToDevice(data.targetDevices, {
//             notification: {
//                 title: data.messageTitle,
//                 body: data.messageBody
//             }
//         });

//         return true;
//     } catch (ex) {
//         return false;
//     }
// });

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
