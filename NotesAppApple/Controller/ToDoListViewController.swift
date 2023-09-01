//
//  ViewController.swift
//  NotesAppApple
//
//  Created by Ananth Nair on 01/09/23.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["purchase appleWatch","check best serum ","add sports shoe in wishlist"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Tableview datasource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: - TableView delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        // for adding (tick - checkmark) in cell based on selected indexpath
        // if it is already selected  we need to uncheck the check mark
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
  //MARK: - Add NewItems
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "AddNotes", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create New item"
            textField = alertTextField
        }
        
        alert.addAction(action)
    
        present(alert, animated: true, completion: nil)
    }
}

