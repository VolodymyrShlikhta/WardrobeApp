//
//  ProfileViewController.swift
//  WardrobeApp
//
//  Created by Igor Khomenko on 12/19/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        guard let user = realm.objects(UserModel.self).first else {return}
        let img = UIImage.init(data: user.userAvatarData)
        
    }
}
