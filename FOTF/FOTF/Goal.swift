//
//  Goal.swift
//  FOTF
//
//  Created by Abhishek Chauhan on 6/5/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import Foundation

class Goal {
    // type holds either Nutrition or Exercise
    var type: String = ""
    var start_date: String = ""
    var end_date: String = ""
    var distance: String = ""
    var calories: String = ""
    // progress and status are natively computed on the device
    var progress: String = ""
    var status: String = "Incomplete"
}
