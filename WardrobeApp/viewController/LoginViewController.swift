//
//  LoginViewController.swift
//  WardrobeApp
//
//  Created by Relorie on 12/27/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAuth

class LoginViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleTextFields()
        signInButton.isEnabled = false
        signInButton.tintColor = .lightGray
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func performSignIn(_ sender: Any) {
        view.endEditing(true)
        SVProgressHUD.show(withStatus: "Logging in...")
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if let error = error {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                return
            }
            SVProgressHUD.showSuccess(withStatus: "Welcome!")
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
