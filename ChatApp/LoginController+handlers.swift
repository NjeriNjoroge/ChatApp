//
//  LoginController+handlers.swift
//  ChatApp
//
//  Created by Grace Njoroge on 17/10/2018.
//  Copyright © 2018 Grace Njoroge. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        print(123)
    }
    
    //selecting image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //capture the edited or original image
        var selectedImage: UIImage?
        
        //extracting the images from info. Both edited and original, edited takes priority
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        //set the profile for user
        if let userProfilePic = selectedImage {
            profileImageView.image = userProfilePic
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //cancelling the picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("cancelled")
    }
    
    //authenticating user
    @objc func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("invalid form")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user , error) in
            
            if error != nil {
                print(error)
                return
            }
            
            guard let uid = user?.user.uid else {
                return
            }
            
            //successfully authenticated user. Save user to database

         /*creating a unique ID for each image*/
            let imageName = NSUUID().uuidString
            
            //upload users image to Firebase
            let storageRef = Storage.storage().reference().child("\(imageName).png")
            
            //compress image to reduce amount of time it loads
            if let uploadData = self.profileImageView.image!.jpegData(compressionQuality: 0.1) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error)
                        }
    
                        let downloadURL = url?.absoluteString
                        let values = ["name": name, "email": email, "profileImageUrl": downloadURL] as [String : Any]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                    })
                })
            }
            
        })
    }
    
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        
        let ref = Database.database().reference(fromURL: "https://chatapp-3df90.firebaseio.com/")
        
        //creating child reference
        let userReference = ref.child("users").child(uid)
        
        
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err)
                return
            }
            //dismiss the view controller when the user is successfully logged in
            print("Saved to DB!!")
            self.messageController?.navigationItem.title = values["name"] as? String
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    
    
}
