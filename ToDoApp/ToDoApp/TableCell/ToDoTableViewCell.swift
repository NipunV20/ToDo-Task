//
//  ToDoTableViewCell.swift
//  ToDoApp
//
//  Created by Apple on 20/06/21.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    // MARK:- Property Objects
    @IBOutlet weak var dateLableObj: UILabel!
    @IBOutlet weak var todoTaskLableObj: UILabel!
    @IBOutlet weak var backgroundViewObj: UIView!
    @IBOutlet weak var deleteButtonObj: UIButton!
    @IBOutlet weak var editButtonObj: UIButton!
    
    //MARK:- Local Objects
    var deleteEntryFromDB:((Int) -> Void)?
    var updateEntryFromDB:((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func displayDataOnCell(_ todoTask: [String: Any], _ index: Int) {
        todoTaskLableObj.text = todoTask["todo_task"] as? String
        dateLableObj.text = todoTask["todo_date"] as? String
        backgroundViewObj.backgroundColor = .random()
        backgroundViewObj.layer.cornerRadius = 8.0
        
        deleteButtonObj.tag = 1000 + index
        editButtonObj.tag = 10000 + index
    }
    
    //MARK:- Actions
    //MARK:- Remove To DO Task from the Local DB
    @IBAction func removeToDoTaskFromList(_ sender: UIButton) {
        let index = sender.tag - 1000
        self.deleteEntryFromDB?(index)
    }
    
    //MARK:- Update ToDo Task
    @IBAction func updateToDoTaskFromList(_ sender: UIButton) {
        let index = sender.tag - 10000
        self.updateEntryFromDB?(index)
    }
    
}
