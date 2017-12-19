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
    
    func getDataFromCalendar() {
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
        if calendar.title == "Work" {
        
        let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
        let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
        
        let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])
        
        let events = eventStore.events(matching: predicate)
        
//        for event in events {
//        titles.append(event.title)
//        startDates.append(event.startDate as NSDate)
//        endDates.append(event.endDate as NSDate)
//        }
        }
        }
    }
}
