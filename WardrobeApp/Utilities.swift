//
//  Utilities.swift
//  WardrobeApp
//
//  Created by Relorie on 12/27/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import Foundation
import SVProgressHUD

class Utilities {
    class func configureSVProgressHUDDefaultValues() {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setFadeInAnimationDuration(0.5)
        SVProgressHUD.setFadeOutAnimationDuration(0.5)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        SVProgressHUD.setMaximumDismissTimeInterval(2)
    }
}
