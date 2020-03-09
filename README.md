# crud_db

Codes written in Flutter and using Firestore as it's database.

## Getting Started
- A Firestore account is required in order for this app to run as the app is depending on the Firestore.
- The following pathing is required in your own Firebase and their names are fixed :-
    A collection named "users" is to be written. The documents of this collection is the unique username and it's collection contains two objects named "entries" and "jobs".

    Please refer to the photo linked below for a better overview:-

    https://muiz.my/foreignassets/firebasetut1.png


- The following Rules are to be copied into the rules part of your Firebase :-

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
		match /users/{uid}/jobs/{document=**} {
    	allow read, write: if request.auth.uid == uid;
    }
    match /users/{uid}/entries/{document=**} {
    	allow read, write: if request.auth.uid == uid;
    }
  }
}

- A manual setup is required depending on your devices and both of them have different requirements and methods.


## Resources

Online documentation of Firebase and Firestore:

- Firebase (https://firebase.google.com/docs)
- Firestore (https://firebase.google.com/docs/firestore)

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
