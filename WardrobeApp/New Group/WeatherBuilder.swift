//
//  WeatherBuilder.swift
//  WardrobeApp
//
//  Created by Nadiia Pavliuk on 12/11/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import Foundation

struct WeatherBuilder {
    var location: String?
    var iconText: String?
    var temperature: String?
    
    var forecasts: [Forecast]?
    
    func build() -> Weather {
        return Weather(location: location!,
                       iconText: iconText!,
                       temperature: temperature!,
                       forecasts: forecasts!)
    }
}
