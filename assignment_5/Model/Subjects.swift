//
//  Courses.swift
//  assignment_5
//
//  Created by vinaya krishna on 11/11/18.
//  Copyright © 2018 vinaya krishna. All rights reserved.
//

import Foundation

struct Subjects {
    let title:String
    let id:Int
    
    init(json:[String:Any]){
        let title = json["title"] as? String
        let id = json["id"] as? Int
        self.title = title!
        self.id = id!
    }
}
