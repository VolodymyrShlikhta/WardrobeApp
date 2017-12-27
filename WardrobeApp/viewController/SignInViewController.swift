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
import SwiftSpinner
import RealmSwift

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
    
    override func viewDidAppear(_ animated: Bool) {
        if true == UserDefaults.standard.bool(forKey: "isLogin") {
            self.performSegue(withIdentifier: "dashboardSegue", sender: self)
        }
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
             SwiftSpinner.show(duration: 3.0, title:  error.localizedDescription, animated: true)
            return
        }
        SwiftSpinner.show("Logging in...")
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            SwiftSpinner.hide()
            if let err = error {
               SwiftSpinner.show(duration: 3.0, title: "Failed to create a Firebase User with FaceBook account: \(err.localizedDescription)", animated: true)
                return
            }
            
            guard let uid = user?.uid else { return }
            print("Successfully logged into Firebase with Facebook", uid)
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
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
}

extension SignInViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser?, withError error: Error!) {
        if user == nil { return }
        SwiftSpinner.show("Logging in...")
        guard let idToken = user?.authentication.idToken else { return }
        guard let accessToken = user?.authentication.accessToken else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            SwiftSpinner.hide()
            if let err = error {
                SwiftSpinner.show(duration: 3.0, title: "Failed to create a Firebase User with Google account: \(err.localizedDescription)", animated: true)

                return
            }
            guard let uid = user?.uid else { return }
            print("Successfully logged into Firebase with Google", uid)
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
}
