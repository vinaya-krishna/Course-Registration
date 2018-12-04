//
//  User.swift
//  assignment_5
//
//  Created by vinaya krishna on 13/11/18.
//  Copyright © 2018 vinaya krishna. All rights reserved.
//

import Foundation

struct User:Codable {
    var firstname: String?
    var lastname: String?
    var redid:String?
    var email:String?
    var password:String?
    
    init(firstName:String,lastName:String,redId:String,email:String,password:String) {
        self.firstname = firstName
        self.lastname = lastName
        self.redid = redId
        self.email = email
        self.password = password
    }
    
//    static func saveData(firstname: String, lastname: String, redid: String, email: String, password: String ){
//        UserDefaults.standard.set(["firstname": firstname, "lastname": lastname, "redid":redid,"email":email,"password":password], forKey: "user")
//    }
    
    static func saveData(user:User ){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "user")
        }
    }
    
//    static func getData() -> User{
//        return User((UserDefaults.standard.value(forKey: "user") as? [String: String]) ?? [:])
//    }
    
    static func getData() -> User?{
        let decoder = JSONDecoder()
        var userData:User?
        
        if let data = UserDefaults.standard.data(forKey: "user"),
            let decodedData = try? decoder.decode(User.self, from: data) {
            userData = decodedData
        }
        return userData
    }
    
    
    
    static func saveUser(user:User ){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: user.email!)
        }
    }

    
    static func getUser(email:String) -> User?{
        let decoder = JSONDecoder()
        var userData:User?
        
        if let data = UserDefaults.standard.data(forKey: email),
            let decodedData = try? decoder.decode(User.self, from: data) {
            userData = decodedData
        }
        return userData
    }
    
}
