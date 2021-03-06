//
//  Exercise.swift
//  FOTF
//
//  Created by Sabrina Niklaus on 6/1/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import Foundation

class Exercise {
    var type: String = ""
    var description: String = ""
    var duration: String = ""
    var reps: String = ""
    var weight: String = ""
    var distance: String = ""
    
    
    public func toAnyObject() -> Any {
        return [
            "type": self.type,
            "description": self.description,
            "duration": self.duration,
            "reps": self.reps,
            "weight": self.weight,
            "distance": self.distance
        ]
    }

}



