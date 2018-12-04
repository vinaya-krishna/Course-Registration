//
//  RegisterViewController.swift
//  assignment_5
//
//  Created by vinaya krishna on 13/11/18.
//  Copyright © 2018 vinaya krishna. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var redId: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onRegister(_ sender: Any) {

        if let firstName = firstName.text, let lastName = lastName.text, let redId = redId.text, let email = email.text, let password = password.text {
            
            if firstName.count == 0 || lastName.count == 0 {
                
                let alert = UIAlertController(title:  "Error", message: "FirstName & LastName regired", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                
            }
            else{
                
                let user = User(firstName: firstName, lastName: lastName, redId: redId, email: email, password: password)
                User.saveData(user: user)
                User.saveUser(user: user)
                
                let payload = ["firstname":firstName,"lastname":lastName,"redid":redId,"password":password,"email":email]
                Requests.postDataRequest(url: "/addstudent", data: payload ) { (res: Any) in
                    let respData = res as! [String:String]
                    switch(respData.keys.first){
                    case "error":
                        print("Error")
                        
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title:  "Error", message: respData[respData.keys.first!], preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                        
                    case "ok":
                        
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title:  "Success", message: respData[respData.keys.first!], preferredStyle: .alert)
                            
                            let clickAction = UIAlertAction(title: "OK", style: .default, handler: { (alert: UIAlertAction) -> Void in
                                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainTab") as! UITabBarController
                                self.present(vc, animated: true, completion: nil)
                            })
                            alert.addAction(clickAction)
                            self.present(alert, animated: true)
                        }
                    default:
                        print("No value found")
                    }
                }
                
            }
        }
    }
}
