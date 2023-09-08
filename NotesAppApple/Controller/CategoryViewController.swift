//
//  CategoryViewController.swift
//  NotesAppApple
//
//  Created by Ananth Nair on 05/09/23.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categoryArray : Results <Category>?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCatogery()
        
    }

    //MARK: - TableView delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoitems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCatogery = categoryArray?[indexPath.row]
        }
    }
    //MARK: - TableView DataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vc = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        vc.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Category found"
        return vc
             
    }
    //MARK: - Add Button Tapped
    @IBAction func AddBtnTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Catogery", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { alertField in
            alertField.placeholder = "Create new Catogery"
            textField = alertField
        }
        present(alert,animated: true, completion: nil)
    }
    
    //MARK: - Model manupulation Methods
    
    func save(category : Category){
        do{
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving catogery \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCatogery(){
        
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
   
}
