//
//  SignInViewController.swift
//  WardrobeApp
//
//  Created by Relorie on 12/27/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth
import SVProgressHUD


class SignInViewController: UIViewController {
    
    @IBOutlet weak var signInAnon: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createNewAccountButton: UIButton!
    let fbButton = FBSDKLoginButton()
    let googleButton = GIDSignInButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFacebookButton()
        setupGoogleButton()
        setupOtherButtons()
    }

    func setupFacebookButton() {
        fbButton.center = view.center
        fbButton.delegate = self
        fbButton.readPermissions = ["public_profile"]
        
        view.addSubview(fbButton)
        fbButton.translatesAutoresizingMaskIntoConstraints = false
        
        fbButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fbButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    func setupGoogleButton() {
        let googleButton = GIDSignInButton()
        view.addSubview(googleButton)
        googleButton.frame = fbButton.frame
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleButton.bottomAnchor.constraint(equalTo: fbButton.topAnchor, constant: -16).isActive = true
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func setupOtherButtons() {
        createNewAccountButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInAnon.translatesAutoresizingMaskIntoConstraints = false
        createNewAccountButton.topAnchor.constraint(equalTo: fbButton.bottomAnchor, constant: 16).isActive  = true
        createNewAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        signInAnon.topAnchor.constraint(equalTo: createNewAccountButton.bottomAnchor, constant: 16).isActive = true
        signInAnon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        signInButton.topAnchor.constraint(equalTo: signInAnon.bottomAnchor, constant: 16).isActive  = true
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        signInButton.layer.cornerRadius = 0.05 * signInButton.bounds.size.width
        signInButton.layer.borderColor = UIColor.gray.cgColor
        signInButton.layer.borderWidth = 1.0
        signInButton.clipsToBounds = true

        createNewAccountButton.layer.cornerRadius = 0.05 * createNewAccountButton.bounds.size.width
        createNewAccountButton.layer.borderColor = UIColor.gray.cgColor
        createNewAccountButton.layer.borderWidth = 1.0
        createNewAccountButton.clipsToBounds = true
        
        signInAnon.layer.cornerRadius = 0.05 * signInAnon.bounds.size.width
        signInAnon.layer.borderColor = UIColor.gray.cgColor
        signInAnon.layer.borderWidth = 1.0
        signInAnon.clipsToBounds = true
        
    }
    
    @IBOutlet weak var signInPressed: UIButton!
    @IBAction func loginAnonymously(_ sender: Any) {
        Auth.auth().signInAnonymously { (user, err) in
            if let err = err {
                self.presentAlert(forError: err)
                return
            }
            self.performSegue(withIdentifier: "dashboardSegue", sender: self)
        }
    }
    
    private func presentAlert(forError err: Error) {
        let alert = UIAlertController.init(title: "Error!", message: err.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1.5
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension SignInViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if result.isCancelled == true { return }
        if error != nil {
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            return
        }
        SVProgressHUD.show(withStatus: "Logging in...")
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let err = error {
                SVProgressHUD.showError(withStatus: "Failed to create a Firebase User with Facebook account: \(err.localizedDescription)")
                return
            }
            
            guard let uid = user?.uid else { return }
            print("Successfully logged into Firebase with Facebook", uid)
            SVProgressHUD.showSuccess(withStatus: "Welcome!")
            self.performSegue(withIdentifier: "dashboardSegue", sender: self)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
}

extension SignInViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser?, withError error: Error!) {
        print("Successfully logged into Google", user )
        if user == nil { return }
        SVProgressHUD.show(withStatus: "Logging in...")
        guard let idToken = user?.authentication.idToken else { return }
        guard let accessToken = user?.authentication.accessToken else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                SVProgressHUD.showError(withStatus: "Failed to create a Firebase User with Google account: \(err.localizedDescription)")
                return
            }
            
            guard let uid = user?.uid else { return }
            print("Successfully logged into Firebase with Google", uid)
            SVProgressHUD.showSuccess(withStatus: "Welcome!")
            self.performSegue(withIdentifier: "dashboardSegue", sender: self)
        })
    }
}
