//
//  LoginViewController.swift
//  assignment_5
//
//  Created by vinaya krishna on 13/11/18.
//  Copyright © 2018 vinaya krishna. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onLogin(_ sender: Any) {
        if let userEmail = email.text,let userPassword = password.text {
            
            if (userEmail.count == 0 || userPassword.count == 0){
                let alert = UIAlertController(title:  "Error", message: "Email/Password Invalid", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else{
                
                if let userData = User.getUser(email: userEmail){
                    User.saveData(user: userData)
                    if userData.password == userPassword {
                        print("Yes")
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainTab") as! UITabBarController
                        self.present(vc, animated: true, completion: nil)
                    }
                    else{
                        let alert = UIAlertController(title:  "Error", message: "Incorrect Password", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
                else{
                    let alert = UIAlertController(title:  "Error", message: "Email/Password Invalid", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                
                
            }

        }
    }
}
