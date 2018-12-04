//
//  Classes.swift
//  assignment_5
//
//  Created by vinaya krishna on 11/11/18.
//  Copyright © 2018 vinaya krishna. All rights reserved.
//

import Foundation

struct Classes:Codable {
    let id:Int
    let title:String
    let fullTitle:String?
    let instructor:String?
    let startTime:String?
    let endTime:String?
    let dept:String?
    let subject:String?
    let courseNo:String?
    let building:String?
    let roomNo:String?
    let days:String?
    let scheduleNo:String?
    let description:String?
    let seats:Int?
    let enrolled:Int?

    
    
    init(json:[String:Any]) {

        self.id = json["id"] as! Int
        self.title = json["title"] as! String
        self.instructor = json["instructor"] as? String
        self.startTime = json["startTime"] as? String
        self.endTime = json["startTime"] as? String
        self.dept = json["department"] as? String
        self.subject = json["subject"] as? String
        self.courseNo = json["course#"] as? String
        self.building = json["building"] as? String
        self.roomNo = json["room"] as? String
        self.days = json["days"] as? String
        self.fullTitle = json["fullTitle"] as? String
        self.scheduleNo = json["schedule#"] as? String
        self.description = json["description"] as? String
        self.seats = json["seats"] as? Int
        self.enrolled = json["enrolled"] as? Int
    }

}


