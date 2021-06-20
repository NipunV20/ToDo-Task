//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by Apple on 20/06/21.
//

import UIKit
import UserNotifications

class AddTaskViewController: UIViewController {
    
    //MARK:- Property Objects
    @IBOutlet weak var headerLabelObj: UILabel!
    @IBOutlet weak var saveUpdateButtonObj: UIButton!
    @IBOutlet weak var alertSwitchObj: UISwitch!
    @IBOutlet weak var taskDateObj: UITextField!
    @IBOutlet weak var taskDetailsObj: UITextView!
    @IBOutlet weak var backgroundViewObj: UIView!
    
    //MARK:- Local Objects
    var datePickerObj = UIDatePicker()
    var isToDoAlert = "false"
    var toDoListArray: [[String:Any]] = []
    var indexVal = -1
    var selectedDate = ""
    var selectedTime = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Premitted")
            } else {
                print("Not Permitted")
            }
        }
        
        datePickerObj = UIDatePicker.init()
        datePickerObj.minimumDate = Date()
        datePickerObj.addTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
        
        backgroundViewObj.layer.cornerRadius = 8.0
        taskDateObj.inputView = datePickerObj
        fetchDataFromLocalDB()
        if indexVal >= 0 {
            setValuesInUI()
        }
    }
    
    func fetchDataFromLocalDB() {
        if let loadedTasks = UserDefaults.standard.array(forKey: "ToDo_Task_List") as? [[String: String]] {
            toDoListArray = loadedTasks
        }
    }
    
    func setValuesInUI() {
        let dict = toDoListArray[indexVal]
        headerLabelObj.text = "Edit"
        saveUpdateButtonObj.setTitle("Update", for: .normal)
        taskDateObj.text = dict["todo_date"] as? String
        taskDetailsObj.text = dict["todo_task"] as? String
        if dict["todo_alert"] as! String == "true" {
            alertSwitchObj.setOn(true, animated: true)
        } else {
            alertSwitchObj.setOn(false, animated: true)
        }
    }
    
    func scheduleNotification(_ selectedDate: Array<String>, selectedTime: Array<String>) {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "ToDo Task Alert"
        content.body = ""
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.day = Int(selectedDate[0])
        dateComponents.month = Int(selectedDate[1])
        dateComponents.year = Int(selectedDate[2])
        dateComponents.hour = Int(selectedTime[0])
        dateComponents.minute = Int(selectedTime[1])
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    //MARK:- Actions
    //MARK:-
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yy HH:mm a"
        taskDateObj.text = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        selectedDate = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "hh:mm"
        selectedTime = dateFormatter.string(from: sender.date)
    }
    
    //MARK:- Save or Update task details
    
    @IBAction func saveUpdateTaskDetails(_ sender: UIButton) {
        if taskDateObj.text?.count == 0 {
            self.AskConfirmation(title: "ToDo Task!", message: "Please select task date")
        } else if taskDetailsObj.text.count == 0 {
            self.AskConfirmation(title: "ToDo Task!", message: "Please enter task details")
        } else {
            let dict: [String: String] = ["todo_task": taskDetailsObj.text, "todo_date": taskDateObj.text ?? "", "todo_alert": isToDoAlert]
            if indexVal >= 0 {
                toDoListArray.remove(at: indexVal)
                toDoListArray.insert(dict, at: indexVal)
            } else {
                toDoListArray.append(dict)
            }
            UserDefaults.standard.set(toDoListArray, forKey: "ToDo_Task_List")
            UserDefaults.standard.synchronize()
            
            let dateElementArray = selectedDate.components(separatedBy: "-")
            let timeElementArray = selectedTime.components(separatedBy: ":")
            if isToDoAlert == "true" {
                scheduleNotification(dateElementArray, selectedTime: timeElementArray)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:- Close current screen & back navigate to the previous screen
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Trun On/Off switch for task alert
    
    @IBAction func turenOnOrOffAlert(_ sender: UISwitch) {
        isToDoAlert = "\(sender.isOn)"
    }
    
}
