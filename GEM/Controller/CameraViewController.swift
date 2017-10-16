//
//  CameraViewController.swift
//  GEM
//
//  Created by Emre Özdil on 10/10/2017.
//  Copyright © 2017 Emre Özdil. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import ProjectOxfordFace

enum PhotoType {
    case login
    case register
}

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var button: UIButton!
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    var actIdc: UIActivityIndicatorView!
    
    var usersStorageRef: StorageReference!
    var personImage: UIImage!
    var photoType: PhotoType!
    
    var faceFromPhoto: MPOFace!
    var faceFromFirebase: MPOFace!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://gem-ios-3a8e7.appspot.com/")
        usersStorageRef = storageRef.child("users")
    }
    
    func setUpCameraView() {
        // MARK: X, Y, Width, Height
        cameraView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cameraView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        cameraView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set Up camera settings
        let deviceSession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera,.builtInTelephotoCamera,.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        
        for device in (deviceSession.devices) {
            
            if device.position == AVCaptureDevice.Position.front {
                
                do {
                    
                    let input = try AVCaptureDeviceInput(device: device)
                    
                    if captureSession.canAddInput(input){
                        captureSession.addInput(input)
                        
                        if captureSession.canAddOutput(sessionOutput){
                            captureSession.addOutput(sessionOutput)
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                            previewLayer.connection?.videoOrientation = .portrait
                            
                            cameraView.layer.addSublayer(previewLayer)
                            cameraView.addSubview(button)
                            
                            previewLayer.position = CGPoint (x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                            previewLayer.bounds = cameraView.frame
                            
                            captureSession.startRunning()
                            
                        }
                    }
                } catch let avError {
                    print(avError)
                }
            }
        }
    }
    
    // Capture Photo function
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if error != nil {
            print(error?.localizedDescription ?? "error")
            let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "error", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = photoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            
            // Reference to Firabase Storage
            let userID = Auth.auth().currentUser?.uid
            let imageRef = usersStorageRef.child("\(userID!).jpg")
            
            
            showActivityIndicator(onView: self.view)
            if photoType == PhotoType.register{
                
                self.personImage = UIImage(data: dataImage)
                
                let client = MPOFaceServiceClient(subscriptionKey: "56b200942b664e06b998dd9e30b93dfe")!
                
                let data = UIImageJPEGRepresentation(self.personImage!, 0.8)
                
                // Detect real-time photo
                client.detect(with: data!, returnFaceId: true, returnFaceLandmarks: true, returnFaceAttributes: [], completionBlock: { (faces, error) in
                    
                    if error != nil {
                        print(error!)
                        Database.database().reference(fromURL: "https://gem-ios-3a8e7.firebaseio.com/").child("users").child(Auth.auth().currentUser!.uid).removeValue(completionBlock: { (error, refer) in
                            if error != nil {
                                print(error?.localizedDescription ?? "error")
                            } else {
                                print("User removed correctly from database")
                            }
                        })
                        let user = Auth.auth().currentUser
                        user?.delete { error in
                            if let error = error {
                                print(error)
                            } else {
                                print("User successfully deleted from Firebase Auth")
                                
                            }
                        }
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "error", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    // Control the number of face
                    if (faces!.count) > 1 || (faces!.count) == 0 {
                        print("There is more than one or no face in the picture")
                        Database.database().reference(fromURL: "https://gem-ios-3a8e7.firebaseio.com/").child("users").child(Auth.auth().currentUser!.uid).removeValue(completionBlock: { (error, refer) in
                            if error != nil {
                                print(error?.localizedDescription ?? "error")
                            } else {
                                print("User removed correctly from database")
                            }
                        })
                        let user = Auth.auth().currentUser
                        user?.delete { error in
                            if let error = error {
                                print(error)
                            } else {
                                print("User successfully deleted from Firebase Auth")
                                
                            }
                        }
                        let alert = UIAlertController(title: "Error", message: "There is more than one or no face in the picture", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                        self.failLogin()
                        return
                    }
                    
                    // Upload to Firebase Storage
                    let uploadTask = imageRef.putData(dataImage, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            let user = Auth.auth().currentUser
                            user?.delete { error in
                                if let error = error {
                                    print(error)
                                } else {
                                    print("User successfully deleted")
                                }
                            }
                            let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "error", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                self.dismiss(animated: true, completion: nil)
                            })
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        else{
                            self.actIdc.stopAnimating()
                            
                            print("Picture is saved successfully")
                            let alert = UIAlertController(title: "Successful", message: "Picture is saved successfully", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                self.previewLayer.removeFromSuperlayer()
                                let viewController = ViewController()
                                let navigationController = UINavigationController(rootViewController: viewController)
                                self.present(navigationController, animated: true, completion: nil)
                            })
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                    
                    uploadTask.resume()
                    
                })
                self.captureSession.stopRunning()
                
            }else if photoType == PhotoType.login {
                
                self.personImage = UIImage(data: dataImage)
                
                captureSession.stopRunning()
                
                // Download from Firebase Storage
                imageRef.downloadURL(completion: { (url, error) in
                    
                    if error != nil {
                        print(error!)
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "error", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    self.verify(withURL: url!.absoluteString)
                })
            }
        }
    }
    
    func verify(withURL url: String) {
        
        let client = MPOFaceServiceClient(subscriptionKey: "56b200942b664e06b998dd9e30b93dfe")!
        
        let data = UIImageJPEGRepresentation(self.personImage!, 0.8)
        
        // Detect real-time photo
        client.detect(with: data, returnFaceId: true, returnFaceLandmarks: true, returnFaceAttributes: [], completionBlock: { (faces, error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "error", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if (faces!.count) > 1 || (faces!.count) == 0 {
                print("There is more than one or no face in the picture")
                let alert = UIAlertController(title: "Error", message: "There is more than one or no face in the picture", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                self.failLogin()
                self.actIdc.stopAnimating()
                return
            }
            
            self.faceFromPhoto = faces![0]
            
            // Detect storage photo
            client.detect(withUrl: url, returnFaceId: true, returnFaceLandmarks: true, returnFaceAttributes: [], completionBlock: { (faces, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "error", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                self.faceFromFirebase = faces![0]
                
                // Verify photos
                client.verify(withFirstFaceId: self.faceFromPhoto.faceId, faceId2: self.faceFromFirebase.faceId, completionBlock: { (result, error) in
                    
                    if error != nil{
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "error", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    self.actIdc.stopAnimating()
                    if result!.isIdentical {
                        // The person is same
                        let viewController = ViewController()
                        let navigationController = UINavigationController(rootViewController: viewController)
                        self.present(navigationController, animated: true, completion: nil)
                        
                    }else {
                        self.failLogin()
                    }
                })
            })
        })
    }
    
    // Loading view
    func showActivityIndicator(onView: UIView) {
        let container: UIView = UIView()
        container.frame = onView.frame
        container.center = onView.center
        container.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = onView.center
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actIdc = UIActivityIndicatorView()
        actIdc.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actIdc.hidesWhenStopped = true
        actIdc.activityIndicatorViewStyle = .whiteLarge
        actIdc.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        
        loadingView.addSubview(actIdc)
        container.addSubview(loadingView)
        onView.addSubview(container)
        
        actIdc.startAnimating()
    }
    
    func failLogin() {
        do {
            try Auth.auth().signOut()
        }catch{
        }
        
        let alert = UIAlertController(title: "Failed Login", message: "Not the same person", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func takePhoto() {
        let settings = AVCapturePhotoSettings()
        self.sessionOutput.capturePhoto(with: settings, delegate: self)
    }
}
