//
//  Goal.swift
//  FOTF
//
//  Created by Abhishek Chauhan on 6/5/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import Foundation

class Goal {
    // types include Nutrition, Distance, Time, Weight, Reps, and Weight Loss
    var type: String = ""
    var currentWeight: String = ""
    var goalWeight: String = ""
    var start_date: String = ""
    var end_date: String = ""
    var goalValue: String = ""
    var calories: String = ""
    // progress and status are natively computed on the device
    var progress: String = ""
    var status: String = "Incomplete"
    
    public func toAnyObject() -> Any {
        return [
            "type": self.type,
            "currentWeight": self.currentWeight,
            "goalWeight": self.goalWeight,
            "startdate": self.start_date,
            "enddate": self.end_date,
            "calories": self.calories,
            "progress": self.progress,
            "status": self.status,
            "goalValue": self.goalValue
        ]
    }
}
