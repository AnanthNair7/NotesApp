//
//  ViewController.swift
//  NotesAppApple
//
//  Created by Ananth Nair on 01/09/23.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCatogery : Category?{
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    
    //MARK: - Tableview datasource method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done == true ? .checkmark : .none
        return cell
    }
    
    //MARK: - TableView delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    //MARK: - Add NewItems
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "AddNotes", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCatogery
            self.itemArray.append(newItem)
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
        
        do{
            try context.save()
        }catch {
            print("error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - LoadItems
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        //In above func -> if it has request param it will take the request  NSFetchRequest<Item>
        //or else it will take default value --->  Item.fetchRequest()
        
        
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        //..while we are sending the request as param ,so we are not creating another request constant
        
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCatogery!.name!)
        //        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate,categoryPredicate])
        //        request.predicate = compoundPredicate
        
        //  using optional chaining we are refatoring above two line of codes
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate ,categoryPredicate] )
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error while Fetching request \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Seachbar Methods
extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text)
        //        let predicate = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
        //        request.predicate = predicate
        //         refactoring above 2 line
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
        
        //        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        //        request.sortDescriptors = [sortDescriptor]
        //        refactoring above 2 line
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        //        do {
        //            itemArray = try context.fetch(request)
        //        } catch {
        //            print("Error while doing seachBar Search\(error)")
        //        }
        
        // refactoring above do try catch block .. it similar to loadItem() methods ,so here we are modifying the loaditem method by adding parameters and  then we are calling loaditem() method here
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

