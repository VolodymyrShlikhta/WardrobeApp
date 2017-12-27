//
//  ProfileViewController.swift
//  WardrobeApp
//
//  Created by Igor Khomenko on 12/19/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth
import SwiftSpinner

class ProfileViewController: UIViewController {

    var userModel: UserModel?
    
    // MARK: Outlets
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var signOutButton: UIButton!
    
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        signOutButton.layer.cornerRadius = 0.05 * signOutButton.bounds.size.width
        signOutButton.layer.borderColor = UIColor.gray.cgColor
        signOutButton.layer.borderWidth = 1.0
        signOutButton.clipsToBounds = true

        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
    }
    
    private func loadData() {
        let realm = try! Realm()
        guard let userModel = realm.objects(UserModel.self).first else {
            signOutButton.setTitle("Create account", for: .normal)
            signOutButton.addTarget(self, action: #selector(transferToLogin), for: UIControlEvents.touchUpInside)
            return
        }
        self.userModel = userModel
        signOutButton.addTarget(self, action: #selector(signOut), for: UIControlEvents.touchUpInside)
        signOutButton.setTitle("Sign Out", for: .normal)
        setupExistingUser()
    }
    
    fileprivate func setupExistingUser() {
        guard let userModel = userModel else { return }
        profileImageView.image = UIImage.init(data: userModel.userAvatarData)
        emailLabel.text = userModel.userEmail
        genderLabel.text = "Gender: \(userModel.userGendr)"
    }
    
    @objc func transferToLogin() {
        performSegue(withIdentifier: "signInProfileSegue", sender: self)
    }
    
    @objc func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            SwiftSpinner.show(duration: 3.0, title: signOutError.localizedDescription, animated: true)
            return;
        }
        UserDefaults.standard.set(false, forKey: "isLogin")
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        performSegue(withIdentifier: "signInProfileSegue", sender: self)
    }
    
}
