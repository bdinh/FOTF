//
//  Food.swift
//  FOTF
//
//  Created by Sabrina Niklaus on 5/25/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import Foundation

class Food {
    var title: String = ""
    var calories: String = ""
    var fat: String = ""
    var sodium: String = ""
    var cholesterol: String = ""
    var sugar: String = ""
    var protein: String = ""
    var servingSize: String = ""
    var servingUnit: String = ""
    var brand: String = ""
    var qty: String = "0"
    
//    init(title: String, calories: String, fat: String, sodium: String, cholesterol: String,
//         sugar: String, protein: String, servingSize: String, servingUnit: String, brand: String) {
//        self.title = title
//        self.calories = calories
//        self.fat = fat
//        self.sodium = sodium
//        self.cholesterol = cholesterol
//        self.sugar = sugar
//        self.protein = protein
//        self.servingSize = servingSize
//        self.servingUnit = servingUnit
//        self.brand = brand
//    }
    
    public func toAnyObject() -> Any {
        return [
            "title": self.title,
            "calories": self.calories,
            "fat": self.fat,
            "sodium": self.sodium,
            "cholesterol": self.cholesterol,
            "sugar": self.sugar,
            "protein": self.protein,
            "servingSize": self.servingSize,
            "servingUnit": self.servingUnit,
            "brand": self.brand,
            "qty": self.qty
        ]
    }
}
