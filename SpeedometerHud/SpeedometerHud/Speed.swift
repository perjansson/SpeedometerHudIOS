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
    
    init(speedInMps : Double) {
        self.speedInMps = speedInMps
    }
    
    func speedInMph() -> String {
        return String(Int(self.speedInMps * 2.2369))
    }
    
    func speedInKmh() -> String {
        return String(Int(self.speedInMps * 3.6))
    }
    
}