//
//  ViewController.swift
//  Cloaker
//
//  Created by Emre Özdil on 05/10/2017.
//  Copyright © 2017 Emre Özdil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    let logOutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.addSubview(logOutButton)
        setLogOutButton()
        
        // User is not logged in
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout))
        }
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        let vc = LoginRegisterViewController()
        self.present(vc, animated: true, completion: nil)
//        let loginRegisterViewController = CameraViewController()
//        loginRegisterViewController.photoType = .register
//        present(loginRegisterViewController, animated: true, completion: nil)
//        let cameraViewController = UIStoryboard(name: "Camera", bundle: nil).instantiateInitialViewController() as! CameraViewController
//
//        cameraViewController.photoType = .login
//        self.present(cameraViewController, animated: true, completion: nil)
    }
    
    func setLogOutButton() {
        // MARK: X, Y, Width, Height
        logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logOutButton.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logOutButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
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

