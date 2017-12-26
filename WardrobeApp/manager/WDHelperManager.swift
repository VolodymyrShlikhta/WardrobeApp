//
//  WDHelperManager.swift
//  WardrobeApp
//
//  Created by Igor Khomenko on 12/26/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit

class WDHelperManager: NSObject {
    
    static let sharedInstance: WDHelperManager = {
        let instance = WDHelperManager()
        return instance
    }()
    override init() {
        super.init()
    }
    
    func getHelperTextForCalendarEvent() -> String {
        let ev = WDCalendarManager.sharedInstance.getNearestEvent()
        var text = ""
        switch ev.calendarName {
        case "Work":
            text = String.init(format: "Don't forget about %@. Suit up, because Barney says so 😎", ev.eventTitle)
        case "Birthdays":
            text = String.init(format: "Don't forget to wish happy birthday %@ 🎁🎂", ev.eventTitle)
        default:
            text = String.init(format: "Greate planing for today, beter to have a good look 🤪", ev.eventTitle)
        }
        return text
    }
    
    func getHelperTextForWeatherDescription(description: Int32) -> String {
        let mes = ForecastMessage.Message.self
        
        switch description {
// MARK: - thunderstorm
            
        case 200, 201, 202:
            return mes.thunderstorm1.rawValue
       case 210, 211, 212, 221:
            return mes.thunderstorm2.rawValue
       case 230, 231, 232:
            return mes.thunderstorm3.rawValue
            
// MARK: - Drizzle
            
        case 300, 301, 302, 310, 311, 312:
            return mes.drizzle1.rawValue
        case 313, 314, 321:
            return mes.drizzle2.rawValue
            
// MARK: - Rain
            
        case 500, 501:
            return mes.rain1.rawValue
        case 502:
            return mes.rain2.rawValue
        case 503:
            return mes.rain3.rawValue
        case 504:
            return mes.rain4.rawValue
        case 511, 531:
            return mes.rain5.rawValue
        case 520, 521, 522:
            return mes.rain6.rawValue
            
// MARK: - Snow
        case 600, 601, 602:
            return mes.snow1.rawValue
        case 611, 612, 615, 616:
            return mes.snow2.rawValue
        case 620:
            return mes.snow3.rawValue
        case 621:
            return mes.snow4.rawValue
        case 622:
            return mes.cold2.rawValue
            
// MARK: - Atmosphere
        case 701, 711, 721, 731, 741:
            return mes.atmosphere1.rawValue
        case 751, 761, 762, 771, 781:
            return mes.atmosphere2.rawValue
            
// MARK: - Clear
        case 800:
            return mes.clear.rawValue
            
// MARK: - Clouds
        case 801, 802:
            return mes.clouds1.rawValue
        case 803, 804:
            return mes.clouds2.rawValue
            
// MARK: - Cold
        case  903,956,955:
            return mes.cold1.rawValue
        case 904:
            return mes.hot1.rawValue
            
// MARK: - Storm
        case 900, 901, 960, 961:
            return mes.storm.rawValue
            
// MARK: - Wind
        case 902, 905, 906, 952, 953, 954, 957, 958, 959, 962:
            return mes.wind.rawValue
            
// MARK: - Calm
        case 951:
            return mes.calm.rawValue
        default:
            return mes.mesDefault.rawValue
        }
    }
}
