//
//  LoginViewController.swift
//  WardrobeApp
//
//  Created by Relorie on 12/27/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import SwiftSpinner
import FirebaseAuth
import RealmSwift

class LoginViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleTextFields()
        passwordTextField.isSecureTextEntry = true
        signInButton.isEnabled = false
        signInButton.tintColor = .lightGray
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func performSignIn(_ sender: Any) {
        view.endEditing(true)
        SwiftSpinner.show("Logging in...")
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            SwiftSpinner.hide()
            if let error = error {
                SwiftSpinner.show(duration: 3.0, title: error.localizedDescription, animated: true)
                return
            }
            SwiftSpinner.show(duration: 3.0, title: "Welcome!", animated: true)
            let realm = try! Realm()
            
            let profileData = UserModel()
            profileData.userFirstName = (user?.displayName)!
            profileData.userLastName = ""
            profileData.userNickName = ""
            profileData.userGendr = ""
            profileData.userEmail = (user?.email)!
            let data = try? Data(contentsOf: (user?.photoURL)!)
            profileData.userAvatarData = data!
            try! realm.write {
                realm.add(profileData)
            }
            UserDefaults.standard.set(true, forKey: "isLogin")
            self.performSegue(withIdentifier: "dashboardSegue", sender: self)
        })

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextFields() {
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                signInButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                signInButton.isEnabled = false
                return
        }
        signInButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        signInButton.isEnabled = true
    }
}
