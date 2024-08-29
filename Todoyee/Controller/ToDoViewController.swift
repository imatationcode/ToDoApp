//
//  ViewController.swift
//  Todoyee
//  Created by Shivakumar Harijan on 17/08/24.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {
    var taskListArray = [TaskList]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .red
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadTasks()
    }
    
    //MARK: to Load the Presistant data on device loadTasks
    func loadTasks() {
        let requestVar: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        
        do {
            taskListArray = try context.fetch(requestVar)
        } catch {
            print("Error While Fetching data from core Data\n \(error)")
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
            let newTask = TaskList(context: self.context)
            newTask.taskName = taskTitleTextField.text!
            newTask.isCompletedTask = false
            self.taskListArray.append(newTask)
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
        tableView.deselectRow(at: indexPath, animated: true)
        saveIteamsAndState()
    }
    
    //MARK: saveIteamsN Status Function
    
    func saveIteamsAndState() {
        do {
            try self.context.save()
        } catch {
            print("Error While Saving context \(error)")
        }
        tableView.reloadData()
    }

}//class End

