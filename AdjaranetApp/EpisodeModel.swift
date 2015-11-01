//
//  EpisodeModel.swift
//  AdjaranetApp
//
//  Created by vakhtang gelashvili on 10/10/15.
//  Copyright © 2015 vakhtang gelashvili. All rights reserved.
//

import Foundation

class EpisodeModel: NSObject {
    
     var name:String = "";
     var lang:String = "";
    var quality:String = "";
    var number:Int=0;
    var season:Int=0
    init(name:String,lang:String,quality:String,number:Int,season:Int){
        self.name=name;
        self.lang=lang;
        self.quality=quality;
        self.number=number;
        self.season=season;
    }
    
}