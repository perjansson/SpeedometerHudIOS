//
//  Speed.swift
//  SpeedometerHud
//
//  Created by Per Jansson on 2014-12-07.
//  Copyright (c) 2014 Per Jansson. All rights reserved.
//

import Foundation

class Speed {
    
    var speedInMps : Double!
    var course : Double?
    
    init(speedInMps : Double) {
        self.speedInMps = speedInMps
    }
    
    init(speedInMps : Double, course : Double) {
        self.speedInMps = speedInMps
        self.course = course
    }
    
    func speedInMph() -> String {
        return String(Int(self.speedInMps * 2.2369))
    }
    
    func speedInKmh() -> String {
        return String(Int(self.speedInMps * 3.6))
    }
    
    func hasCourse() -> Bool {
        return course != nil
    }
    
    func cardinalDirection() -> String {
        var direction : String = ""
        
        if (course >= 350 && course < 23) {
            direction = "north"
        }
        else if(course >= 23 && course < 68) {
            direction = "north east"
        }
        else if(course >= 68 && course < 113) {
            direction = "east"
        }
        else if(course >= 113 && course < 185) {
            direction = "south east"
        }
        else if(course >= 185 && course < 203) {
            direction = "south"
        }
        else if(course >= 203 && course < 249) {
            direction = "south west"
        }
        else if(course >= 249 && course < 293) {
            direction = "west"
        }
        else if(course >= 293 && course < 350) {
            direction = "north west"
        }
        
        return direction
    }
    
}