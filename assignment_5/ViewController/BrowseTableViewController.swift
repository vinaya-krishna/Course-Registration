//
//  BrowseTableViewController.swift
//  assignment_5
//
//  Created by vinaya krishna on 12/11/18.
//  Copyright © 2018 vinaya krishna. All rights reserved.
//

import UIKit

class BrowseTableViewController: UITableViewController {

    var subjects = [Subjects]()
    
    @IBOutlet var subjectTableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        subjectTableview.dataSource = self
        subjectTableview.delegate = self
        
        Requests.getDataRequest(url: "/subjectlist") { (jsonData:Any) in
            let jsonArray = jsonData as! [[String:Any]]
            for item in jsonArray{
                let subjectObj = Subjects(json: item)
                self.subjects.append(subjectObj)
                DispatchQueue.main.async {
                    self.subjectTableview.reloadData()
                }
            }
        }
        
    
    }

    // MARK: - Table view data source
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subjects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectcell", for: indexPath)

        
//        let label1 = cell.contentView.viewWithTag(101) as! UILabel
//        label1.text = String(self.subjects[indexPath.row].id)
//            
//        let label2 = cell.contentView.viewWithTag(102) as! UILabel
//        label2.text = self.subjects[indexPath.row].title
        
        cell.textLabel!.text = self.subjects[indexPath.row].title
        
   
        return cell
    }
    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "courseSegue", sender: self)
//    }
    

    
    
//     MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "subjectSegue") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! FilterViewController
                controller.selectedSubject = self.subjects[indexPath.row]
            }
        }
    }


}
