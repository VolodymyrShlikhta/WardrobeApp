//
//  ForecastViewModel.swift
//  WardrobeApp
//
//  Created by Nadiia Pavliuk on 12/11/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import Foundation

struct ForecastViewModel {
    let time: Observable<String>
    let iconText: Observable<String>
    let temperature: Observable<String>
    
    init(_ forecast: Forecast) {
        time = Observable(forecast.time)
        iconText = Observable(forecast.iconText)
        temperature = Observable(forecast.temperature)
    }
}


