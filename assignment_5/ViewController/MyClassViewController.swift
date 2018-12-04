//
//  MyClassViewController.swift
//  assignment_5
//
//  Created by vinaya krishna on 17/11/18.
//  Copyright © 2018 vinaya krishna. All rights reserved.
//

import UIKit

class MyClassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    var registeredClasses = [Classes]()
    
    @IBOutlet weak var resisteredClassTable: UITableView!
//    @IBOutlet weak var waitlistedClassTable: UITableView!
    
    @IBAction func onDropClass(_ sender: AnyObject) {
        let indexPath = self.getIndexPath(of: sender, in: resisteredClassTable)
        self.unregisterClass(from: indexPath!)
    }
    
    
    private func getIndexPath(of element:Any, in tableview:UITableView)->IndexPath?{
        if let view = element as? UIView {
            let position = view.convert(CGPoint.zero, to:tableview)
            return tableview.indexPathForRow(at: position)
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resisteredClassTable.dataSource=self
        resisteredClassTable.delegate = self
    
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateStudentClasses()
        
    }
    
    private func updateStudentClasses(){
        self.registeredClasses.removeAll()
        if let user = User.getData(){
            Requests.postDataRequest(url: "/studentclasses", data: ["redid":user.redid!, "password": user.password!]) { (jsonData:Any) in
                if let respDict = jsonData as? [String:[Int]]{
                    print(respDict)
                    
                    
                    
                    let registeredClasseIds = respDict["classes"]!
                    
                    if registeredClasseIds.count == 0 {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Info", message: "No Registered Class Found", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                    
                    let data = ["classids":registeredClasseIds]
                    Requests.postDataRequest(url: "/classdetails", data: data, onCompletion: { (res:Any) in
                        let resArray = res as! [[String:Any]]
                        for item in resArray{
                            let classDetail = Classes(json:item)
                            self.registeredClasses.append(classDetail)
                            print(classDetail)
                            DispatchQueue.main.async {
                                self.resisteredClassTable.reloadData()
                            }
                        }
                    })
                    DispatchQueue.main.async {
                        self.resisteredClassTable.reloadData()
                    }
                }
            }
        }
    }
    
    private func unregisterClass(from indexPath:IndexPath){
        print(self.registeredClasses[indexPath.row].id)
    
        if let user = User.getData(){
            let payloaddata:[String:Any] = ["redid":user.redid!,"password":user.password!,"courseid":self.registeredClasses[indexPath.row].id]
            Requests.postDataRequest(url: "/unregisterclass", data: payloaddata) { (jsonData:Any) in
                if let respDict = jsonData as? [String:String]{
                    let keyExists = respDict["ok"] != nil
                    if (keyExists){
                        self.updateStudentClasses()
                    }
                    
                }
            }
        }
    }

    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "myclassSegue") {
            if let indexPath = self.resisteredClassTable.indexPathForSelectedRow {
                let controller = segue.destination as! DetailsViewController
                controller.selectedClassDetail = self.registeredClasses[indexPath.row]
            }
        }
        
        
    }
 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.registeredClasses.count
    }
 

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        cell = tableView.dequeueReusableCell(withIdentifier: "myclasscell", for: indexPath)
        
        let title = cell!.contentView.viewWithTag(102) as! UILabel
        title.text = String(self.registeredClasses[indexPath.row].fullTitle ?? "NA")
        
        let course = cell!.contentView.viewWithTag(101) as! UILabel
        course.text = String(self.registeredClasses[indexPath.row].subject ?? "NA") + "-" + String(self.registeredClasses[indexPath.row].courseNo ?? "NA")
        
        let time = cell!.contentView.viewWithTag(103) as! UILabel
        time.text = String(self.registeredClasses[indexPath.row].startTime ?? "NA") + " - " + String(self.registeredClasses[indexPath.row].endTime ?? "NA")
        
        let day = cell!.contentView.viewWithTag(104) as! UILabel
        day.text = String(self.registeredClasses[indexPath.row].days ?? "NA")
       
        
        let location = cell!.contentView.viewWithTag(105) as! UILabel
       
        location.text = String(self.registeredClasses[indexPath.row].building ?? "NA") + " - " + String(self.registeredClasses[indexPath.row].roomNo ?? "NA")
        
        let instructor = cell!.contentView.viewWithTag(106) as! UILabel
        instructor.text = String(self.registeredClasses[indexPath.row].instructor ?? "NA")
        
        return cell!
    }

}
