//
//  ProfileViewController.swift
//  assignment_5
//
//  Created by vinaya krishna on 25/11/18.
//  Copyright © 2018 vinaya krishna. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var redId: UILabel!
    @IBOutlet weak var email: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = User.getData(){
            self.firstName.text = user.firstname
            self.lastName.text = user.lastname
            self.redId.text = user.redid
            self.email.text = user.email
        }
       

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func resetAll(_ sender: Any) {
        if let user = User.getData(){
            let reseturl = "/resetstudent?redid=\(user.redid!)&password=\(user.password!)"
            Requests.getDataRequest(url: reseturl, onCompletion: { (res: Any) in
                if let respDict = res as? [String:Any]{
                    
                    let key = Array(respDict.keys)[0]
                    let value = respDict[key] as! String
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title:  key, message: value, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            })
        }
    }
    

}
