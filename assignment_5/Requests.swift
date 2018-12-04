//
//  HTTPReq.swift
//  assignment_5
//
//  Created by vinaya krishna on 11/11/18.
//  Copyright © 2018 vinaya krishna. All rights reserved.
//

import Foundation

struct Requests {
    
    static let basepath = "https://bismarck.sdsu.edu/registration"
    
    static func getDataRequest(url:String, onCompletion:@escaping (Any)->()){
        
        let path = "\(basepath)\(url)"
        
        if let url = URL(string: path) {
            URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?,error:Error?) in
                guard let data = data, error == nil, response != nil else{
                    print("Something is wrong")
                    return
                }
                
                let httpResponse = response as? HTTPURLResponse
                let status:Int = httpResponse!.statusCode
               
                if (status == 200) {
                    do {
                        let respJson:Any = try JSONSerialization.jsonObject(with: data)
                        onCompletion(respJson)
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                   
                }
            }.resume()
        }
        else {
            print("Unable to create URL")
        }
    }
    
    static func postDataRequest(url:String, data:[String:Any], onCompletion:@escaping (Any)->()){
        
        let path = "\(basepath)\(url)"
        
        let jsonifiedData = try? JSONSerialization.data(withJSONObject: data)

        
        if let url = URL(string: path) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonifiedData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
                guard let data = data, error == nil, response != nil else {
                    print("Something is wrong")
                    return
                }
            
                do {
                    let json:Any = try JSONSerialization.jsonObject(with: data, options: [])
                    onCompletion(json)
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            task.resume();
        }
        else {
            print("Unable to create URL")
        }
    }
}
