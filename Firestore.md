### How to add firestore to flutter apps

#### Follow the video tutorial to create and add firebase project

Create firestore db and add firestore security rules

- Update the rules with below code
- You can learn more about firebase firestore security rules [here](https://firebase.google.com/docs/firestore/security/get-started)

- Below rules states that you can read and write to firestore only if you are authenticated.

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth.uid != null;
    }
  }
}
```

### Let's create a form to add data to firestore

- See file form.dart

### Complete below task

- Function to add data to firestore
- Function to get data from firestore (by user id) Stream
- Function to get data from firestore (by user id) Future
- Sort and Filter
