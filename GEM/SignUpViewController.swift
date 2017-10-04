//
//  SignUpViewController.swift
//  GEM
//
//  Created by Emre Özdil on 03/10/2017.
//  Copyright © 2017 Emre Özdil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func signUpButton(_ sender: UIButton) {
        
        guard emailField.text != "", passwordField.text != "", passwordField.text != "" else {
            return
        }
        
        if passwordField.text == passwordConfirmField.text {
            let shaData = HashPassword.sha256(string:passwordField.text!)
            let shaHex =  shaData!.map { String(format: "%02hhx", $0) }.joined()
            print("shaHex: \(shaHex)")
            Auth.auth().createUser(withEmail: emailField.text!, password: shaHex) { (user, error) in
                if error != nil {
                    print(error!)
                } else {
                    let cameraViewController = UIStoryboard(name: "Camera", bundle: nil).instantiateInitialViewController() as! CameraViewController
                    
                    cameraViewController.photoType = .signup
                    self.present(cameraViewController, animated: true, completion: nil)
                }
            }
        } else {
            let alert = UIAlertController(title: "Password does not match", message: "Please put correct password on both fields", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
}
