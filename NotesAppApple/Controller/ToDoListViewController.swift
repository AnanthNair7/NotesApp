//
//  ViewController.swift
//  NotesAppApple
//
//  Created by Ananth Nair on 01/09/23.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // calling userDefaults
    
  //  let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        print(dataFilePath)
//
//        let newItem =  Item()
//        newItem.title = "purchase appleWatch"
//        itemArray.append(newItem)
//
//
//        let newItem1 =  Item()
//        newItem1.title = "check best serum"
//        itemArray.append(newItem1)
//
//        let newItem2 =  Item()
//        newItem2.title = "check best shoes"
//        itemArray.append(newItem2)
//
        
        //  loading userdefaults array
//        if let  item = defaults.array(forKey: "NotesAppArray") as?  [Item] {
//            itemArray = item
//        }
        
        // calling methods to store data
        
        loadItems()
    }
    
    //MARK: - Tableview datasource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //        if item .done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        // refactoring the above line by ternary operator
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        // for adding (tick - checkmark) in cell based on selected indexpath
        // if it is already selected  we need to uncheck the check mark
        
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        
        
        // we handled above condition in cellForRowAt method in line 53 to 57 to we removed above code here
        
        //        if itemArray[indexPath.row].done == false {
        //            itemArray[indexPath.row].done = true
        //        } else {
        //            itemArray[indexPath.row].done = false
        //        }
        
        // refactoring the line 68 to 72
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
       // tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add NewItems
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "AddNotes", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // before
            // self.itemArray.append(textField.text!)
            // after adding model
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            // Instead of append into array now we are gng to store in user defaults
            
            //self.defaults.set(self.itemArray, forKey: "NotesAppArray")
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create New item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Model manupulation Methods
    
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error in encoding data\(error )")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - LoadItems
    
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                  itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error in decoding data\(error)")
            }
        }
        
        
    }
}

