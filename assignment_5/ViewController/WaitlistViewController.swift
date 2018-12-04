//
//  WaitlistViewController.swift
//  assignment_5
//
//  Created by vinaya krishna on 25/11/18.
//  Copyright © 2018 vinaya krishna. All rights reserved.
//

import UIKit

class WaitlistViewController: UITableViewController {

    var waitlistedClasses = [Classes]()
    
    @IBOutlet var waitlistTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateStudentClasses()
        
    }
    
    private func updateStudentClasses(){
        self.waitlistedClasses.removeAll()
        if let user = User.getData(){
            Requests.postDataRequest(url: "/studentclasses", data: ["redid":user.redid!, "password": user.password!]) { (jsonData:Any) in
                if let respDict = jsonData as? [String:[Int]]{
                    print(respDict)
                    
                    let registeredClasseIds = respDict["waitlist"]!
                    
                    if registeredClasseIds.count == 0 {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Info", message: "No Waitlisted Class Found", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                    
                    let data = ["classids":registeredClasseIds]
                    Requests.postDataRequest(url: "/classdetails", data: data, onCompletion: { (res:Any) in
                        let resArray = res as! [[String:Any]]
                        
                        for item in resArray{
                            let classDetail = Classes(json:item)
                            self.waitlistedClasses.append(classDetail)
                            print(classDetail)
                            DispatchQueue.main.async {
                                self.waitlistTable.reloadData()
                            }
                        }
                        
                    })
                    DispatchQueue.main.async {
                        self.waitlistTable.reloadData()
                    }
                }
            }
        }
    }
    
    
    
   
    @IBAction func onDrop(_ sender: Any) {
        let indexPath = self.getIndexPath(of: sender, in: waitlistTable)
        self.unwaitlistClass(from: indexPath!)
    }
    
    private func unwaitlistClass(from indexPath:IndexPath){
        print(self.waitlistedClasses[indexPath.row].id)
        
        if let user = User.getData(){
            let payloaddata:[String:Any] = ["redid":user.redid!,"password":user.password!,"courseid":self.waitlistedClasses[indexPath.row].id]
            Requests.postDataRequest(url: "/unwaitlistclass", data: payloaddata) { (jsonData:Any) in
                if let respDict = jsonData as? [String:String]{
                    let keyExists = respDict["ok"] != nil
                    if (keyExists){
                        self.updateStudentClasses()
                    }
                    
                }
            }
        }
    }
    
    
    private func getIndexPath(of element:Any, in tableview:UITableView)->IndexPath?{
        if let view = element as? UIView {
            let position = view.convert(CGPoint.zero, to:tableview)
            return tableview.indexPathForRow(at: position)
        }
        return nil
    }
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.waitlistedClasses.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "waitlistcell", for: indexPath)

        let title = cell.contentView.viewWithTag(102) as! UILabel
        title.text = String(self.waitlistedClasses[indexPath.row].fullTitle ?? "NA")
        
        let course = cell.contentView.viewWithTag(101) as! UILabel
        course.text = String(self.waitlistedClasses[indexPath.row].subject ?? "NA") + "-" + String(self.waitlistedClasses[indexPath.row].courseNo ?? "NA")

        return cell
    }

}
