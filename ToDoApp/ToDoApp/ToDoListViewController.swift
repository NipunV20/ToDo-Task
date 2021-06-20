//
//  ViewController.swift
//  ToDoApp
//
//  Created by Apple on 20/06/21.
//

import UIKit


class ToDoListViewController: UIViewController {

    //MARK:- Property Objects
    
    @IBOutlet weak var todoTableViewObj: UITableView!
    @IBOutlet weak var noTaskLabelObj: UILabel!
    @IBOutlet weak var addNewTaskButtonObj: UIButton!
    
    //MARK:- Local Objects
//    var toDoListArray: Array = []
//    var toDoListArray = [[String: Any]]()
    var toDoListArray: [[String:Any]] = []
    var toDoListArrayCopy: [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addNewTaskButtonObj.setShadowofButton()
        fetchDataFromLocalDB()
        
        if toDoListArray.count == 0 {
            todoTableViewObj.isHidden = true
            noTaskLabelObj.isHidden = false
        } else {
            todoTableViewObj.isHidden = false
            noTaskLabelObj.isHidden = true
            todoTableViewObj.reloadData()
        }
    }
    
    func fetchDataFromLocalDB() {
        if let loadedTasks = UserDefaults.standard.array(forKey: "ToDo_Task_List") as? [[String: String]] {
            print(loadedTasks)
            toDoListArray = loadedTasks
            toDoListArrayCopy = loadedTasks
        }
    }
    
    @IBAction func goToAddNewTaskViewController(_ sender: UIButton) {
        let addTaskVC = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController")
        self.navigationController?.pushViewController(addTaskVC!, animated: true)
    }
    
    
    
}

extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate {
    // number of rows in table view
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.toDoListArray.count
        }
        
        // create a cell for each table view row
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoTableViewCell") as! ToDoTableViewCell
            let todoDict = toDoListArray[indexPath.row]
            cell.displayDataOnCell(todoDict, indexPath.row)
            cell.deleteEntryFromDB = { (selectedIndex) in
                self.toDoListArray.remove(at: selectedIndex)
                UserDefaults.standard.set(self.toDoListArray, forKey: "ToDo_Task_List")
                UserDefaults.standard.synchronize()
                tableView.reloadData()
            }
            cell.updateEntryFromDB = { (selectedIndex) in
                let addTaskVC = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
                addTaskVC.indexVal = selectedIndex
                self.navigationController?.pushViewController(addTaskVC, animated: true)
            }
            return cell
        }
}
