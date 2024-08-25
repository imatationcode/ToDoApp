//
//  ViewController.swift
//  Todoyee
//  Created by Shivakumar Harijan on 17/08/24.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var taskListArray = [TaskModalClass]()
    var newTask : TaskModalClass!
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDoDataFile.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .red
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton
        print(dataFilePath!)
        loadTasks()
    }
    
    //MARK: to Load the Presistant data on device loadTasks
    func loadTasks() {
        if let tasksData = try? Data(contentsOf: dataFilePath!) {
            let myDecoer = PropertyListDecoder()
            do {
                self.taskListArray = try myDecoer.decode([TaskModalClass].self, from: tasksData)
            } catch {
                print("Error while decoding\(error)")
            }
        }
    }
    
    @objc func addNewTask() {
        var taskTitleTextField = UITextField()
        let alert = UIAlertController(title: "New Task", message: "", preferredStyle: .alert)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add Neew Task"
            taskTitleTextField = alertTextField
        }
        
        let addTaskButton = UIAlertAction(title: "Add This", style: .default) { addAction in
            self.newTask = TaskModalClass()
            self.newTask?.taskName = taskTitleTextField.text!
            self.taskListArray.append(self.newTask!)
            self.saveIteamsAndState()
        }
        alert.addAction(addTaskButton)
        self.present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskListArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoIdentifier", for: indexPath)
        let reversedIndex = taskListArray.count - 1 - indexPath.row
        
        cell.textLabel?.text = taskListArray[reversedIndex].taskName
        
        cell.accessoryType = taskListArray[reversedIndex].isCompletedTask == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK: table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reversedIndex = taskListArray.count - 1 - indexPath.row
        taskListArray[reversedIndex].isCompletedTask.toggle()
        saveIteamsAndState()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: saveIteamsN Status Function
    
    func saveIteamsAndState() {
        let myEncoder = PropertyListEncoder()
        do {
            let data = try myEncoder.encode(taskListArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error While Encoding")
        }
        tableView.reloadData()
    }

}//class End

