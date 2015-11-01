//
//  SeasonModel.swift
//  AdjaranetApp
//
//  Created by vakhtang gelashvili on 10/10/15.
//  Copyright © 2015 vakhtang gelashvili. All rights reserved.
//

import Foundation
class SeasonModel: NSObject {
    
    var name:String = "";
    var episodes:NSMutableArray=NSMutableArray()
    init(name:String){
        self.name=name;
    }
    
    
    
}