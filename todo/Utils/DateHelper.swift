//
//  DateHelper.swift
//  todo
//
//  Created by Chris Kimber on 8/09/22.
//
import Foundation
import SwiftDate

class DateHelper {
    static func now() -> DateInRegion {
        return DateInRegion(Date(), region: Region.current)
    }
    
    static func isToday(_ date: DateInRegion) -> Bool {
        let now = DateHelper.now()
        return (now > date.dateAtStartOf(.day) && now < date.dateAtEndOf(.day))
    }
}
