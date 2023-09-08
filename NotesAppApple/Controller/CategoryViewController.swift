//
//  CategoryViewController.swift
//  NotesAppApple
//
//  Created by Ananth Nair on 05/09/23.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCatogery()
        
    }

    //MARK: - TableView delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(categoryArray[indexPath.row].name)
        performSegue(withIdentifier: "gotoitems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCatogery = categoryArray[indexPath.row]
        }
    }
    //MARK: - TableView DataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vc = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        vc.textLabel?.text = categoryArray[indexPath.row].name
        return vc
             
    }
    //MARK: - Add Button Tapped
    @IBAction func AddBtnTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Catogery", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categoryArray.append(newCategory)
            self.saveCatogery()
        }
        alert.addAction(action)
        alert.addTextField { alertField in
            alertField.placeholder = "Create new Catogery"
            textField = alertField
        }
        present(alert,animated: true, completion: nil)
    }
    
    //MARK: - Model manupulation Methods
    
    func saveCatogery(){
        do{
            try context.save()
        } catch {
            print("Error saving catogery \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCatogery(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
           categoryArray =  try context.fetch(request)
        }catch {
            print("Error while loading \(error)")
        }
        tableView.reloadData()
    }
   
}
