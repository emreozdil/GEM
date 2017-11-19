# GEM [![Travis CI](https://travis-ci.com/emreozdil/GEM.svg?token=W1PFc5VyLR7zwNLsVzpB&branch=master)](https://travis-ci.com/emreozdil/GEM/builds)

## Introduction
Two-factor authentication login application.
1. Email and password authentication via Firebase
2. Facial authentication verifies whether the database view and the current view are the same via Microsoft Face API

## Requirements
- Swift 4
- Xcode 9.0+
- Firebase
- ProjectOxfordFace (Microsoft Face API)

## Usage
Modify project settings and API functions

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

Then, run the following command:

```bash
$ pod install
```

### Change bundle identifier and development team
<img src="https://firebasestorage.googleapis.com/v0/b/gem-ios-3a8e7.appspot.com/o/Project%20Settings.png?alt=media&token=6eaf3975-2424-46ac-b827-e42e53f9adbc">




### Firebase and ProjectOxfordFace
Using Firebase back-end API and ProjectOxfordFace Face API

Set Your Own Face API Key
```swift
let client = MPOFaceServiceClient(subscriptionKey: "Microsoft Face API KEY")!
```

#### Registration
User authentication, add to database and store of photo

<img src="/Screenshots/register.PNG" width="320px">
##### Register User
```swift
Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
}
```

##### User Added to Database
```swift
guard let uid = user?.uid else {
    return
}
let ref = Database.database().reference(fromURL: "FIREBASE_URL")
let userReference = ref.child("users").child(uid)

let values = [
    "name": name,
    "email": email,
    "password": shaHex // sha256 password
]
userReference.updateChildValues(values, withCompletionBlock: { (error, reference) in
}
```
##### User Photo Detect and Save Storage
```swift
let userID = Auth.auth().currentUser?.uid
let imageRef = usersStorageRef.child("\(userID!).jpg")

client.detect(with: data!, returnFaceId: true, returnFaceLandmarks: true, returnFaceAttributes: [], completionBlock: { (faces, error) in

    let uploadTask = imageRef.putData(dataImage, metadata: nil, completion: { (metadata, error) in

    })

    uploadTask.resume()

})
```
<img src="/Screenshots/camera.PNG" width="320px">
<img src="/Screenshots/welcome.PNG" width="320px">

#### Login
User authentication, verify between storage photo and real-time photo

<img src="/Screenshots/login.PNG" width="320px">

##### Login User
```swift
Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
}
```

##### Verify Photos
```swift
var faceFromPhoto: MPOFace!
var faceFromFirebase: MPOFace!

// Detect real-time photo
client.detect(with: data, returnFaceId: true, returnFaceLandmarks: true, returnFaceAttributes: [], completionBlock: { (faces, error) in
  self.faceFromPhoto = faces![0]

  // Detect storage photo
  client.detect(withUrl: url, returnFaceId: true, returnFaceLandmarks: true, returnFaceAttributes: [], completionBlock: { (faces, error) in
      self.faceFromFirebase = faces![0]

        // Verify photos
        client.verify(withFirstFaceId: self.faceFromPhoto.faceId, faceId2: self.faceFromFirebase.faceId, completionBlock: { (result, error) in
            if result!.isIdentical {
                // THE PERSON IS THE SAME
                // Open logged in view
            }
        })
    })
})
```
