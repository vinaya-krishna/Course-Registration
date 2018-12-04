//
//  DetailsViewController.swift
//  assignment_5
//
//  Created by vinaya krishna on 16/11/18.
//  Copyright © 2018 vinaya krishna. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var selectedClassDetail:Classes?
    var classRegData:[String:Any] = [:]
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instructorLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var deptLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var courseNoLabel: UILabel!
    @IBOutlet weak var buildingLabel: UILabel!
    @IBOutlet weak var roomNoLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var schNoLabel: UILabel!
    @IBOutlet weak var desrLabel: UILabel!
    
    @IBOutlet weak var waitlistButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    //    @IBOutlet weak var classTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waitlistButton.isHidden = true
        
        
        if let user = User.getData(){
            self.classRegData["redid"] = user.redid!
            self.classRegData["password"] = user.password!
            self.classRegData["courseid"] = selectedClassDetail?.id
        }

        
        
        
        
        titleLabel.text = selectedClassDetail?.fullTitle ?? selectedClassDetail?.title
        instructorLabel.text = selectedClassDetail?.instructor ?? "NA"
        startLabel.text = selectedClassDetail?.startTime ?? "NA"
        endLabel.text = selectedClassDetail?.endTime ?? "NA"
        deptLabel.text = selectedClassDetail?.dept ?? "NA"
        subLabel.text = selectedClassDetail?.subject ?? "NA"
        courseNoLabel.text = selectedClassDetail?.courseNo ?? "NA"
        buildingLabel.text = selectedClassDetail?.building ?? "NA"
        roomNoLabel.text = selectedClassDetail?.roomNo ?? "NA"
        daysLabel.text = selectedClassDetail?.days ?? "NA"
        schNoLabel.text = selectedClassDetail?.scheduleNo ?? "NA"
        desrLabel.text = selectedClassDetail?.description ?? "NA"
        

        
        if let entrolled = selectedClassDetail?.enrolled, let seats = selectedClassDetail?.seats{
            let availableSeats = seats - entrolled
            if (availableSeats == 0){
                let alert = UIAlertController(title:  "Alert", message: "Course is Full", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                self.waitlistButton.isHidden = false
                self.registerButton.isHidden = true
            }
        }
        
        
    }
    
    
    @IBAction func onAdd(_ sender: Any) {
        Requests.postDataRequest(url: "/registerclass", data: classRegData) { (jsonData:Any) in
            if let respDict = jsonData as? [String:Any]{
                
                let key = Array(respDict.keys)[0]
                let value = respDict[key] as! String
                var title:String?
                
                DispatchQueue.main.async {
                    if key == "ok"{
                        title = "Info"
                    }
                    else{
                        title = "Error"
                    }
                    let alert = UIAlertController(title:  title, message: value, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    
//                    let equal = (value == "Course is full")
//                    if equal {
//                        self.waitlistButton.isHidden = false
//                    }
                }
                
            }
        }
    }
    
    @IBAction func onWaitlist(_ sender: Any) {
        Requests.postDataRequest(url: "/waitlistclass", data: classRegData) { (jsonData:Any) in
            if let respDict = jsonData as? [String:Any]{
                print(respDict)
                let key = Array(respDict.keys)[0]
                let value = respDict[key] as! String
                
                DispatchQueue.main.async {
                    var title:String?
                    if key == "ok"{
                        title = "Info"
                    }
                    else{
                        title = "Error"
                    }
                    
                    let alert = UIAlertController(title:  title, message: value, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                
            }
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
