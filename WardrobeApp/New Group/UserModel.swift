//
//  UserModel.swift
//  WardrobeApp
//
//  Created by Igor Khomenko on 12/27/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import Foundation
import RealmSwift

class UserModel: Object {
    @objc dynamic var userFirstName = ""
    @objc dynamic var userLastName = ""
    @objc dynamic var userNickName = ""
    @objc dynamic var userGendr = ""
    @objc dynamic var userEmail = ""
    @objc dynamic var userAvatarData = Data()
}
