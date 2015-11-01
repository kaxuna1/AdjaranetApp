//
//  ActorModel.swift
//  AdjaranetApp
//
//  Created by vakhtang gelashvili on 9/6/15.
//  Copyright © 2015 vakhtang gelashvili. All rights reserved.
//


class ActorModel: NSObject {

    internal var actorId:String = "";
    internal var actorName:String = "";
    init(actorId:String,actorName:String){
        self.actorId=actorId;
        self.actorName=actorName;
    }
    
}
