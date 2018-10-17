//
//  LoginController+handlers.swift
//  ChatApp
//
//  Created by Grace Njoroge on 17/10/2018.
//  Copyright © 2018 Grace Njoroge. All rights reserved.
//

import UIKit


extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        print(123)
    }
    
    //
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
}
