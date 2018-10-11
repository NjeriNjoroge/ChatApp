//
//  ViewController.swift
//  ChatApp
//
//  Created by Grace Njoroge on 05/10/2018.
//  Copyright © 2018 Grace Njoroge. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ViewController: UITableViewController {
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
      
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        //user not logged in
        if Auth.auth().currentUser?.uid == nil {
            //handle the warning of presenting too many controllers when the app is starting. Gives it a slight delay
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }


}

