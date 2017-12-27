//
//  TodayViewController.swift
//  wardrobe
//
//  Created by Igor Khomenko on 12/27/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var recomendationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recomendationLabel.text = "--"
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        updateRecomendation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshRecomendation), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
    }
    
    @objc func refreshRecomendation(notification: NSNotification) {
        updateRecomendation()
    }
    
    func updateRecomendation() {
        let sharedDefaults = UserDefaults(suiteName: "group.eleks.TodayExtensionSharingDefaults")
        recomendationLabel.text = sharedDefaults?.object(forKey: "recomendationKey") as? String
    }
}
