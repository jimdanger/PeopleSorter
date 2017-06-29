//
//  Person.swift
//  PeopleSorter
//
//  Created by Jim Wilson on 6/28/17.
//  Copyright © 2017 Jim Danger, LLC. All rights reserved.
//

import Foundation

class Person {
    
    var id: String
    var name: String
    var state: String
    var age: Int
    
    init(id: String, name: String, state: String, age: Int) {
        self.id = id
        self.name = name
        self.state = state
        self.age = age
    }
    
    init(jsonItem: [String:Any?]) {
        self.id = jsonItem["id"]! as! String
        self.name = jsonItem["name"]! as! String
        self.state = jsonItem["state"]! as! String
        self.age = jsonItem["age"]! as! Int
    }
    
}
