//
//  User.swift
//  FOTF
//
//  Created by Brandon Chen on 6/1/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import Foundation

import Foundation

public struct User {
    public var name: String
    public var email: String
    public var age: Int
    public var sex: String
    
    init(name: String, email: String, age: Int, sex: String) {
        self.name = name
        self.email = email
        self.age = age
        self.sex = sex
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func getEmail() -> String {
        return self.email
    }
    
    public func getAge() -> Int {
        return self.age
    }
    
    public func getSex() -> String {
        return self.sex
    }
    
    public func toAnyObject() -> Any {
        return [
            "name": self.name,
            "email": self.email,
            "age": self.age,
            "sex": self.sex
        ]
    }
}
