//
//  FilterViewController.swift
//  assignment_5
//
//  Created by vinaya krishna on 12/11/18.
//  Copyright © 2018 vinaya krishna. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    
    
    var selectedSubject: Subjects!
    var levelData = ["All","lower","upper","graduate"]
    var selectedLevel:String?
    
    @IBOutlet weak var levelPicker: UIPickerView!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.levelPicker.dataSource = self
        self.levelPicker.delegate = self
        
        courseTitle.text = selectedSubject?.title
        
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "searchSegue") {
            let controller = segue.destination as! ClassTableViewController
            controller.subjectID = self.selectedSubject?.id
            if let timeStart = startTime.text, let timeEnd = endTime.text, let level = self.selectedLevel {
                let searchPayload:[String : Any] = ["subjectids":[self.selectedSubject!.id], "level":level, "starttime":timeStart,"endtime":timeEnd]
                print(searchPayload)
                controller.searchPayload = searchPayload
            }
            else{
                let searchPayload:[String : Any] = ["subjectids":[self.selectedSubject!.id], "level":"", "starttime":"","endtime":""]
                print(searchPayload)
                controller.searchPayload = searchPayload
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.levelData.count
    }
 
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return self.levelData[row]
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        print(self.levelData[row])
        selectedLevel = self.levelData[row]
    }

}
