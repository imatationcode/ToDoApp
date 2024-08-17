//
//  ViewController.swift
//  Todoyee
//
//  Created by Shivakumar Harijan on 17/08/24.
//

import UIKit

class ToDoViewController: UITableViewController {
    var taskListArray = ["Shopping", "Study", "Travel" ]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .red
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addNewTask() {
        var taskTitleTextField = UITextField()
        let alert = UIAlertController(title: "New Task", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Add This", style: .default) { addAction in
            print(taskTitleTextField.text!)
            self.taskListArray.append(taskTitleTextField.text!)
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add Neew Task"
            taskTitleTextField = alertTextField
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskListArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoIdentifier", for: indexPath)
        cell.textLabel?.text = taskListArray[indexPath.row]
        return cell
    }
    //MARK: table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

