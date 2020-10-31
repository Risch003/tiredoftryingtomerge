//
//  CommunicationViewController.swift
//  WisHope
//
//  Created by Kyle Cain on 2/16/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import UIKit
import TwilioVideo

class CommunicationViewController: UIViewController {
    var accessToken = "TWILIO_ACCESS_TOKEN"
    
    // Configure remote URL to fetch token from
    var tokenUrl = "http://localhost:8000/token.php"
    
    // Video SDK components
    var room: Room?
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    
    @IBOutlet weak var remoteView: VideoView!
    
    @IBOutlet weak var previewView: VideoView!
    
    @IBOutlet weak var disconnectButton: UIButton!
    
    @IBOutlet weak var muteButton: UIButton!
    
    //made on 10/21/20 by Alexander Auraha
    //button that will be used to toggle video on/off
    //added the button to the corresponding icon in the storyboard
    @IBOutlet weak var videoButton: UIButton!
    
    var roomString:String? = ""
    
    deinit {
        // We are done with camera
        if let camera = self.camera {
            camera.stopCapture()
            self.camera = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(disconnectButton)
        disconnectButton.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        
        Utilities.styleFilledButton(muteButton)
        muteButton.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        
        if PlatformUtils.isSimulator {
            let imageName = "avatar"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image:image!)
            imageView.frame = CGRect(x:0, y:0, width: 120, height:160)
            self.previewView.addSubview(imageView)
            self.previewView.bringSubviewToFront(imageView)
        } else {
            // Preview our local camera track in the local video preview view.
            self.startPreview()
        }
        // Do any additional setup after loading the view.
        
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
                builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [LocalVideoTrack]()
                
                // Use the preferred audio codec
                if let preferredAudioCodec = Settings.shared.audioCodec {
                    builder.preferredAudioCodecs = [preferredAudioCodec]
                }
                
                // Use the preferred video codec
                if let preferredVideoCodec = Settings.shared.videoCodec {
                    builder.preferredVideoCodecs = [preferredVideoCodec]
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
    
    func startPreview() {
        if PlatformUtils.isSimulator {
            return
        }
        
        let frontCamera = CameraSource.captureDevice(position: .front)
        let backCamera = CameraSource.captureDevice(position: .back)
        
        if (frontCamera != nil || backCamera != nil) {
            
            let options = CameraSourceOptions { (builder) in
                // To support building with Xcode 10.x.
                #if XCODE_1100
                if #available(iOS 13.0, *) {
                    // Track UIWindowScene events for the key window's scene.
                    // The example app disables multi-window support in the .plist (see UIApplicationSceneManifestKey).
                    builder.orientationTracker = UserInterfaceTracker(scene: UIApplication.shared.keyWindow!.windowScene!)
                }
                #endif
            }
            // Preview our local camera track in the local video preview view.
            camera = CameraSource(options: options, delegate: self)
            localVideoTrack = LocalVideoTrack(source: camera!, enabled: true, name: "Camera")
            
            // Add renderer to video track for local preview
            localVideoTrack!.addRenderer(self.previewView)
            //logMessage(messageText: "Video track created")
            
            
            camera!.startCapture(device: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                if let error = error {
                    self.logMessage(messageText: "Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                } else {
                    self.previewView.shouldMirror = (captureDevice.position == .front)
                }
            }
        }
        else {
            self.logMessage(messageText:"No front or back capture device found!")
        }
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
    
    //made on 10/21/20 by Alexander Auraha
    //supposed to toggle video on/off
    //added the function to its corresponding button in the storyboard
    @IBAction func toggleVideo ( sender: Any) {
        self.localVideoTrack?.isEnabled = !(self.localVideoTrack?.isEnabled)!
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
        
        // Create a video track which captures from the camera.
        if (localVideoTrack == nil) {
            self.startPreview()
        }
    }
    
    func logMessage(messageText: String) {
        NSLog(messageText)
    }
    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
        // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
        let videoPublications = participant.remoteVideoTracks
        for publication in videoPublications {
            if let subscribedVideoTrack = publication.remoteTrack,
                publication.isTrackSubscribed {
                //setupRemoteVideoView()
                subscribedVideoTrack.addRenderer(self.remoteView!)
                self.remoteParticipant = participant
                return true
            }
        }
        return false
    }

    func renderRemoteParticipants(participants : Array<RemoteParticipant>) {
        for participant in participants {
            // Find the first renderable track.
            if participant.remoteVideoTracks.count > 0,
                renderRemoteParticipant(participant: participant) {
                break
            }
        }
    }

    func cleanupRemoteParticipant() {
        if self.remoteParticipant != nil {
            self.remoteView?.removeFromSuperview()
            self.remoteView = nil
            self.remoteParticipant = nil
        }
    }
}

extension CommunicationViewController : RoomDelegate {
    func roomDidConnect(room: Room) {
        logMessage(messageText: "Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")

        // This example only renders 1 RemoteVideoTrack at a time. Listen for all events to decide which track to render.
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = self
        }
    }

    func roomDidDisconnect(room: Room, error: Error?) {
        logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")
        
        self.cleanupRemoteParticipant()
        self.room = nil
        
        //self.showRoomUI(inRoom: false)
    }

    func roomDidFailToConnect(room: Room, error: Error) {
        logMessage(messageText: "Failed to connect to room with error = \(String(describing: error))")
        self.room = nil
        
        //self.showRoomUI(inRoom: false)
    }

    func roomIsReconnecting(room: Room, error: Error) {
        logMessage(messageText: "Reconnecting to room \(room.name), error = \(String(describing: error))")
    }

    func roomDidReconnect(room: Room) {
        logMessage(messageText: "Reconnected to room \(room.name)")
    }

    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        participant.delegate = self

        logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }

    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")

        // Nothing to do in this example. Subscription events are used to add/remove renderers.
    }
}

extension CommunicationViewController: RemoteParticipantDelegate {

    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
        
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
    }

    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.

        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }

    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.

        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
    }

    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has stopped sharing the audio Track.

        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }

    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // The LocalParticipant is subscribed to the RemoteParticipant's video Track. Frames will begin to arrive now.

        logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")

        if (self.remoteParticipant == nil) {
            _ = renderRemoteParticipant(participant: participant)
        }
    }
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        
        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")

        if self.remoteParticipant == participant {
            cleanupRemoteParticipant()

            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
                let index = remainingParticipants.firstIndex(of: participant) {
                remainingParticipants.remove(at: index)
                renderRemoteParticipants(participants: remainingParticipants)
            }
        }
    }

    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
       
        logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
        
        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }

    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
    }

    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
    }

    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }

    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }

    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }

    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}

// MARK:- VideoViewDelegate
extension CommunicationViewController : VideoViewDelegate {
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        self.view.setNeedsLayout()
    }
}

// MARK:- CameraSourceDelegate
extension CommunicationViewController : CameraSourceDelegate {
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        logMessage(messageText: "Camera source failed with error: \(error.localizedDescription)")
    }
}
