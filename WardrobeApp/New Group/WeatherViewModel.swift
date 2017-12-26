//
//  WeatherViewModel.swift
//  WardrobeApp
//
//  Created by Nadiia Pavliuk on 12/11/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherViewModel {
    // MARK: - Constants
    fileprivate let emptyString = ""
    
    // MARK: - Properties
    let hasError: Observable<Bool>
    let errorMessage: Observable<String?>
    
    let location: Observable<String>
    let iconText: Observable<String>
    let temperature: Observable<String>
    let descriptionID: Observable<Int32>
    let forecasts: Observable<[ForecastViewModel]>
    
    // MARK: - Services
    fileprivate var locationService: LocationService
    fileprivate var weatherService: WeatherServiceProtocol
    
    // MARK: - init
    init() {
        hasError = Observable(false)
        errorMessage = Observable(nil)
        
        location = Observable(emptyString)
        iconText = Observable(emptyString)
        temperature = Observable(emptyString)
        forecasts = Observable([])
        descriptionID = Observable(0)
        // Can put Dependency Injection here
        locationService = LocationService()
        weatherService = OpenWeatherMapService()
    }
    
    // MARK: - public
    func startLocationService() {
        locationService.delegate = self
        locationService.requestLocation()
    }
    
    // MARK: - private
    fileprivate func update(_ weather: Weather) {
        hasError.value = false
        errorMessage.value = nil
        
        location.value = weather.location
        iconText.value = weather.iconText
        temperature.value = weather.temperature
        descriptionID.value = weather.descriptionID
        
        let tempForecasts = weather.forecasts.map { forecast in
            return ForecastViewModel(forecast)
        }
        forecasts.value = tempForecasts
    }
    
    fileprivate func update(_ error: Errors) {
        hasError.value = true
        
        switch error.errorCode {
        case .urlError:
            errorMessage.value = "The weather service is not working."
        case .networkRequestFailed:
            errorMessage.value = "The network appears to be down."
        case .jsonSerializationFailed:
            errorMessage.value = "We're having trouble processing weather data."
        case .jsonParsingFailed:
            errorMessage.value = "We're having trouble parsing weather data."
        }
        descriptionID.value = 0
        location.value = emptyString
        iconText.value = emptyString
        temperature.value = emptyString
        self.forecasts.value = []
    }
}

// MARK: LocationServiceDelegate
extension WeatherViewModel: LocationServiceDelegate {
    func locationDidUpdate(_ service: LocationService, location: CLLocation) {
        weatherService.retrieveWeatherInfo(location) { (weather, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let unwrappedError = error {
                    print(unwrappedError)
                    self.update(unwrappedError)
                    return
                }
                
                guard let unwrappedWeather = weather else {
                    return
                }
                self.update(unwrappedWeather)
            })
        }
    }
}


