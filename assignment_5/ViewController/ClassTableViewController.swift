//
//  ClassTableViewController.swift
//  assignment_5
//
//  Created by vinaya krishna on 12/11/18.
//  Copyright © 2018 vinaya krishna. All rights reserved.
//

import UIKit

class ClassTableViewController: UITableViewController {

    var subjectID:Int?
    var classDetails = [Classes]()
    var searchPayload:[String:Any]?

    @IBOutlet var classTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classTable.dataSource = self
        classTable.delegate = self

        
        Requests.postDataRequest(url: "/classidslist", data: self.searchPayload!) { (res: Any) in
            print(res)
            if let classIDs = res as? [Int]{
                let data = ["classids":classIDs]
                Requests.postDataRequest(url: "/classdetails", data: data, onCompletion: { (res:Any) in
                    let resArray = res as! [[String:Any]]
                    for item in resArray{
                        let classDetail = Classes(json:item)
                        self.classDetails.append(classDetail)
                        print(classDetail)
                        DispatchQueue.main.async {
                            self.classTable.reloadData()
                        }
                    }
                })
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classDetails.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classcell", for: indexPath)
        
        let label1 = cell.contentView.viewWithTag(101) as! UILabel
        label1.text = String(self.classDetails[indexPath.row].subject ?? "NA") + "-" + String(self.classDetails[indexPath.row].courseNo ?? "NA")

        let label2 = cell.contentView.viewWithTag(102) as! UILabel
        label2.text = self.classDetails[indexPath.row].title
//        cell.textLabel!.text = self.classDetails[indexPath.row].title
        
        return cell
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "classSegue") {
            if let indexPath = self.classTable.indexPathForSelectedRow {
                let controller = segue.destination as! DetailsViewController
                controller.selectedClassDetail = self.classDetails[indexPath.row]
            }
        }
    }
    
    
    

}
