//
//  CalendarModel.swift
//  WardrobeApp
//
//  Created by Igor Khomenko on 12/27/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import Foundation
import RealmSwift

class CalendarModel: Object {
    @objc dynamic var eventTitle = ""
    @objc dynamic var eventLocation = ""
    @objc dynamic var calendarName = ""
    @objc dynamic var eventStart = Date()
}
