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
    
    let message: UILabel = {
        let label = UILabel()
        label.text = "Hi!"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.addSubview(message)
        setMessage()
        
        guard let uid = Auth.auth().currentUser?.uid else {
            perform(#selector(handleLogout))
            return
        }
        let ref = Database.database().reference(fromURL: "https://gem-ios-3a8e7.firebaseio.com/")
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            self.message.text = "Hi, \(name)"
        }) { (error) in
            print(error.localizedDescription)
            let alert = UIAlertController(title: "Error", message: error.localizedDescription , preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
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
    }
    
    func setMessage() {
        // MARK: X, Y, Width, Height
        message.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        message.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        message.widthAnchor.constraint(equalToConstant: 250).isActive = true
        message.heightAnchor.constraint(equalToConstant: 50).isActive = true
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

