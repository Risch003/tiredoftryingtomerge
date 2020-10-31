//
//  CallOnlyViewController.swift
//  WisHope
//
//  Created by Alexander Auraha on 10/21/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import UIKit
import TwilioVideo

class CallOnlyViewController: UIViewController {

    var accessToken = "TWILIO_ACCESS_TOKEN"
    
    // Configure remote URL to fetch token from
    var tokenUrl = "http://localhost:8000/token.php"
    
    // Video SDK components
    var room: Room?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    
    
    @IBOutlet weak var disconnectButton: UIButton!
    
    @IBOutlet weak var muteButton: UIButton!
    
    var roomString:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(disconnectButton)
        disconnectButton.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        
        Utilities.styleFilledButton(muteButton)
        muteButton.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        
            // Configure access token either from server or manually.
            // If the default wasn't changed, try fetching from server.
            accessToken = ""

            // Prepare URL
            let url = URL(string: "https://us-central1-wishope-247fd.cloudfunctions.net/appFuncs/access-token")
            guard let requestUrl = url else { fatalError() }

            // Prepare URL Request Object
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
             
            //generate string
        let myString = "userEmail=\(User.email)&room=\(roomString ?? "")"
            
            // HTTP Request Parameters which will be sent in HTTP Request Body
            let postString = myString;
            //print(myString)
            // Set HTTP Request Body
            request.httpBody = postString.data(using: String.Encoding.utf8);
        
            // Perform HTTP Request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    // Check for Error
                    if let error = error {
                        print("Error took place \(error)")
                        return
                    }
             
                    // Convert HTTP Response Data to a String
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        print("Response data string:\n \(dataString)")
                        self.accessToken = dataString
                        //display error if this doesnt work
                    }
            }
            task.resume()
            //MARK:-IMPORTANT
            //please change this to async call or make a call back
            sleep(1)
            
            // Prepare local media which we will share with Room Participants.
            self.prepareLocalMedia()
            // Preparing the connect options with the access token that we fetched (or hardcoded).
            let connectOptions = ConnectOptions(token: accessToken) { (builder) in
                
                // Use the local media that we prepared earlier.
                builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [LocalAudioTrack]()
                
                // Use the preferred audio codec
                if let preferredAudioCodec = Settings.shared.audioCodec {
                    builder.preferredAudioCodecs = [preferredAudioCodec]
                }

                // Use the preferred encoding parameters
                if let encodingParameters = Settings.shared.getEncodingParameters() {
                    builder.encodingParameters = encodingParameters
                }
                
                // Use the preferred signaling region
                if let signalingRegion = Settings.shared.signalingRegion {
                    builder.region = signalingRegion
                }
                builder.roomName = ""
            }
            // Connect to the Room using the options we provided.
        room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
            
            logMessage(messageText: "Attempting to connect to room")
    }
    
    @IBAction func disconnect(_ sender: Any) {
        self.room!.disconnect()
        logMessage(messageText: "Attempting to disconnect from room")
        let homeTabBarController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeTabBarController) as? UITabBarController
        view.window?.rootViewController = homeTabBarController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func toggleMic(_ sender: Any) {
        self.localAudioTrack?.isEnabled = !(self.localAudioTrack?.isEnabled)!
    }
    
    func prepareLocalMedia() {
        
        // We will share local audio and video when we connect to the Room.
        
        // Create an audio track.
        if (localAudioTrack == nil) {
            localAudioTrack = LocalAudioTrack(options: nil, enabled: true, name: "Microphone")
            
            if (localAudioTrack == nil) {
                logMessage(messageText: "Failed to create audio track")
            }
        }
    }
    
    func logMessage(messageText: String) {
        NSLog(messageText)
    }

    func cleanupRemoteParticipant() {
        if self.remoteParticipant != nil {
            self.remoteParticipant = nil
        }
    }
}

extension CallOnlyViewController : RoomDelegate {
    
    //edited on 10/21/20 by Alexander Auraha
    //added the number "2" to the name so that the error would resolve
    func roomDidConnect2(room: Room) {
        logMessage(messageText: "Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")

        // This example only renders 1 RemoteVideoTrack at a time. Listen for all events to decide which track to render.
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = self
        }
    }

    //edited on 10/21/20 by Alexander Auraha
    //added the number "2" to the name so that the error would resolve
    func roomDidDisconnect2(room: Room, error: Error?) {
        logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")
        
        self.cleanupRemoteParticipant()
        self.room = nil
        
        //self.showRoomUI(inRoom: false)
    }

    //edited on 10/21/20 by Alexander Auraha
    //added the number "2" to the name so that the error would resolve
    func roomDidFailToConnect2(room: Room, error: Error) {
        logMessage(messageText: "Failed to connect to room with error = \(String(describing: error))")
        self.room = nil
        
        //self.showRoomUI(inRoom: false)
    }

    //edited on 10/21/20 by Alexander Auraha
    //added the number "2" to the name so that the error would resolve
    func roomIsReconnecting2(room: Room, error: Error) {
        logMessage(messageText: "Reconnecting to room \(room.name), error = \(String(describing: error))")
    }

    //edited on 10/21/20 by Alexander Auraha
    //added the number "2" to the name so that the error would resolve
    func roomDidReconnect2(room: Room) {
        logMessage(messageText: "Reconnected to room \(room.name)")
    }

    //edited on 10/21/20 by Alexander Auraha
    //added the number "2" to the name so that the error would resolve
    func participantDidConnect2(room: Room, participant: RemoteParticipant) {
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        participant.delegate = self

        logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }

    //edited on 10/21/20 by Alexander Auraha
    //added the number "2" to the name so that the error would resolve
    func participantDidDisconnect2(room: Room, participant: RemoteParticipant) {
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")

        // Nothing to do in this example. Subscription events are used to add/remove renderers.
    }
}

extension CallOnlyViewController: RemoteParticipantDelegate {

    //edited on 10/21/20 by Alexander Auraha
    //added the number "2" to the name so that the error would resolve
    func remoteParticipantDidPublishAudioTrack2(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.

        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
    }

    //edited on 10/21/20 by Alexander Auraha
    //added the number "2" to the name so that the error would resolve
    func remoteParticipantDidUnpublishAudioTrack2(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has stopped sharing the audio Track.

        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }
    
    //edited on 10/21/20 by Alexander Auraha
    //added the number "2" to the name so that the error would resolve
    func didSubscribeToAudioTrack2(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
       
        logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    //edited on 10/21/20 by Alexander Auraha
    //added the number "2" to the name so that the error would resolve
    func didUnsubscribeFromAudioTrack2(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
        
        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }

    //edited on 10/21/20 by Alexander Auraha
    //added the number "2" to the name so that the error would resolve
    func remoteParticipantDidEnableAudioTrack2(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }

    //edited on 10/21/20 by Alexander Auraha
    //added the number "2" to the name so that the error would resolve
    func remoteParticipantDidDisableAudioTrack2(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }

    //edited on 10/21/20 by Alexander Auraha
    //added the number "2" to the name so that the error would resolve
    func didFailToSubscribeToAudioTrack2(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }
}
