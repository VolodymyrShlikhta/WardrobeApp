//
//  WeatherViewController.swift
//  WardrobeApp
//
//  Created by Nadiia Pavliuk on 12/11/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices
import SwiftSpinner

//MARK: - UIViewController Properties
class homeViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet var forecastViews: [ForecastView]!
    @IBOutlet weak var recomendationText: UILabel!
    
    let identifier = "WeatherIdentifier"
    
    //MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = WeatherViewModel()
        viewModel?.startLocationService()
        
        recomendationText.text = ForecastMessage.Message.mesDefault.rawValue
        SwiftSpinner.useContainerView(self.view)
        SwiftSpinner.show("Preparing data...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         setRecomendation()
    }
    
    // MARK: ViewModel
    var viewModel: WeatherViewModel? {
        didSet {
            viewModel?.location.observe {
                [unowned self] in
                self.locationLabel.text = $0
                
                let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
                attributeSet.title = self.locationLabel.text
                
                let item = CSSearchableItem(uniqueIdentifier: self.identifier, domainIdentifier: "ios-camp.iWear", attributeSet: attributeSet)
                CSSearchableIndex.default().indexSearchableItems([item]){error in
                    if let error =  error {
                        print("Indexing error: \(error.localizedDescription)")
                    } else {
                        print("Location item successfully indexed")
                        DispatchQueue.main.sync {
                            self.setRecomendation()
                        }
                    }
                }
            }
            
            viewModel?.iconText.observe {
                [unowned self] in
                self.iconLabel.text = $0
            }
            
            viewModel?.temperature.observe {
                [unowned self] in
                self.temperatureLabel.text = $0
            }
            
            viewModel?.forecasts.observe {
                [unowned self] (forecastViewModels) in
                if forecastViewModels.count >= 6 {
                    for (index, forecastView) in self.forecastViews.enumerated() {
                        forecastView.loadViewModel(forecastViewModels[index])
                    }
                }
            }
            
        }
    }
    
    func setRecomendation() {
        if temperatureLabel.text != "" {
            WDCalendarManager.sharedInstance.getDataFromCalendar {
                if WDCalendarManager.sharedInstance.eventsData.count > 0 {
                   self.recomendationText.text = WDHelperManager.sharedInstance.getHelperTextForCalendarEvent()
                } else {
                    self.recomendationText.text = WDHelperManager.sharedInstance.getHelperTextForWeatherDescription(description: (self.viewModel?.descriptionID.value)!)
                }
            }
            SwiftSpinner.hide()
        }
    }
    
}

