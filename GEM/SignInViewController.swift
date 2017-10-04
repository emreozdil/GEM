//
//  SignInViewController.swift
//  GEM
//
//  Created by Emre Özdil on 03/10/2017.
//  Copyright © 2017 Emre Özdil. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func signInButton(_ sender: UIButton) {
        guard emailField.text != "", passwordField.text != "" else {
            return
        }
        let shaData = HashPassword.sha256(string:passwordField.text!)
        let shaHex =  shaData!.map { String(format: "%02hhx", $0) }.joined()
        print("shaHex: \(shaHex)")
        Auth.auth().signIn(withEmail: emailField.text!, password: shaHex) { (user, error) in
            if error != nil {
                print(error!)
            }
            let cameraViewController = UIStoryboard(name: "Camera", bundle: nil).instantiateInitialViewController() as! CameraViewController
            
            cameraViewController.photoType = .signin
            self.present(cameraViewController, animated: true, completion: nil)
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

