//
//  WDCalendarManager.swift
//  WardrobeApp
//
//  Created by Igor Khomenko on 12/19/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import EventKit


class WDCalendarManager: NSObject {
    static let sharedInstance: WDCalendarManager = {
        let instance = WDCalendarManager()
        return instance
    }()
    override init() {
        super.init()
    }
    
    func getDataFromCalendar(competition: @escaping () -> Void) {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            readEvents(competition: {
                competition()
            })
        case .denied:
            competition()
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion: { (granted: Bool, NSError) -> Void in
                if granted {
                    self.readEvents(competition: {
                        competition()
                    })
                }
            })
        default:
            competition()
            break
        }
    }
    
    func readEvents(competition: () -> Void) {
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            print(calendar.title)
            let timeZoonDiferents = (NSTimeZone.local.secondsFromGMT() / 3600) * 60 * 60;
            var myDate = Date()
            myDate = myDate.addingTimeInterval(TimeInterval(timeZoonDiferents))
            let startOfDate = myDate.startOfDay
            let endOfDate = myDate.endOfDay
            
                let predicate = eventStore.predicateForEvents(withStart: startOfDate as Date, end: endOfDate as Date, calendars: [calendar])
            
                let events = eventStore.events(matching: predicate)

                for event in events {
                    competition()
//                    titles.append(event.title)
//                    startDates.append(event.startDate! as NSDate)
//                    endDates.append(event.endDate! as NSDate)
                }
            }
    }

}

extension Date {
    var startOfDay : Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay : Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
}
