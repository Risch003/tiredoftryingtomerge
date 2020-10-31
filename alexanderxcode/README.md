# WisHope iOS

WisHope is a porject with the goal of providing resources to individuals struggling with mental or behavioral health. the app will accoplish this in a few ways: Daily wellness questionnaires, an interactive map of resources, and a way to reach out to life coaches through chat, video, or voice calls.

## Installation/Downloads

* download and install xcode from the app store
* install cocoapods
```bash
$ sudo gem install cocoapods
```
* clone repository
* cd into directory you cloned and install pods
```bash
$ pod install
$ pod update
```

## What does it still need

# Firebase Cloud Messaging

NOTE: You will need an iPhone to do any testing on this. The iPhone simulator doesn't allow you to recieve notifications from a remote source. Also, you'll need to authorize your machine to build the app with a certificate to get remote notifcations.

Currently, the app is able to recieve notifcations from FCM. However, it is not integrated with our firestore functions. The goal is to be able to both send a recieve information from FCM in order to place two users in a room together. When an iphone user recieves a push notification from wishope they should be able to click it and end up in a room with another user. UPDATE: Completed, but still needs to look more like recieving a call. Also You will need a solution to differentiate remote notifications.

Ideally, we would like for this experience to be similar to when you recieve an actual call on your phone. (whole screen notifcation, swipe to answer, etc)


# Twilio

Voice-only chat and potentially direct messages

Both of these would require different libraries than what are currently installed for programmable video. The code and methods used for building storyboards should be similar to how I laid everything out in my communication controller and storyboard. Twilio also has projects viewable on github to demo their services. That will be the msot valuable information that you can find for this.

You'll also need access to the twilio console. Message zaid on teams and one of us can get you in the login info. The console, at least for video, has a tool to manually generate tokens. This is very useful for testing.

You'll have to write some server code to make these services automated. There's already a repo for all of this, so just add to that. You'll then have to deploy those as cloud functions.

# Firebase/Firestore

You'll have to get added to the project. Message zaid on teams to have him add you. We use Firebase for authentication/database/server functions/and fcm, so it's important to be familiar. 

Currently we make a call to updateUserPresence to update the users presence (this was a node server before we moved it here). Eventually, you'll be wanting to do it in [this](https://firebase.google.com/docs/firestore/solutions/presence) way. It uses built in functions rather than making a call to our code.

# UI

There is a mock up for what the UI should look like in your teams group, but I wouldn't be suprised if there need to be changes to it. Contact Zaid and see where he would like to go with that. Most of the functionallity that you need in the app is already there, it just needs a fresh coat of paint.

