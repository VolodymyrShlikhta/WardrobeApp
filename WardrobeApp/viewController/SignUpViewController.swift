//
//  SignUpViewController.swift
//  WardrobeApp
//
//  Created by Relorie on 12/26/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class SignUpViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    var selectedImage : UIImage?
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleTextFields()
        passwordTextField.isSecureTextEntry = true
        signUpButton.setTitleColor(UIColor.lightText, for: UIControlState.disabled)
        configureImageView()
        configureSignUpButton()
    }
    
    func configureSignUpButton() {
        signUpButton.layer.cornerRadius = 0.2 * signUpButton.bounds.size.width
        signUpButton.layer.borderColor = UIColor.lightGray.cgColor
        signUpButton.layer.borderWidth = 1.0
        signUpButton.clipsToBounds = true
        signUpButton.isEnabled = false
    }
    
    @objc func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    func configureImageView() {
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        let profileImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView ))
        profileImageView.addGestureRecognizer(profileImageTapGesture)
        profileImageView.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextFields() {
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signUpButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            signUpButton.isEnabled = false
            return
        }
        signUpButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        signUpButton.isEnabled = true
    }
    
    @IBAction func performSignUp(_ sender: UIButton) {
        view.endEditing(true)
        SVProgressHUD.show(withStatus: "Waiting...")
        if let profileImage = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil{
                    SVProgressHUD.showError(withStatus: "\(error?.localizedDescription ?? "" )")
                    return
                }
                // save image to realm on response segue to dashboard
                
                
            }
        }else {
            SVProgressHUD.showError(withStatus: "Profile must have a picture.")
        }
    }
    
    
    
    @IBAction func haveAccountPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any] ) {
        if let newProfileImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = newProfileImage
            profileImageView.image = newProfileImage
        }
        dismiss(animated: true, completion: nil)
    }
}
