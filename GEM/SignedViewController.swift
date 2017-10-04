//
//  SignedViewController.swift
//  GEM
//
//  Created by Emre Özdil on 04/10/2017.
//  Copyright © 2017 Emre Özdil. All rights reserved.
//

import UIKit

class SignedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signOutButton(_ sender: Any) {
        let signOutViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
        self.present(signOutViewController, animated: true, completion: nil)
    }
    
}
