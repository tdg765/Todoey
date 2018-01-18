//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Tom Daniel Home on 16/1/18.
//  Copyright © 2018 Thomas Daniel. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
    
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tavleView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     let destinationVC = segue.destination as! ToDoListViewController
    
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Add New Catgories

    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
     
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category:", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if textField.text == "" {
                
            } else {
                
                //Need to use self.context to refer to global context as it is within a closure.
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                self.categoryArray.append(newCategory)
                
                self.saveCategories()
                
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//MARK: - Data Manipulation Methods
    
    func    saveCategories() {
        
        do {
            
            try   context.save()
            
        }   catch   {
            
            print("Error saving context \(error)")
            
        }
        
        //This reloads the UITableView view update with the data that has already been added.
        tableView.reloadData()
        
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        //Says we are requesting data in the form of Item.
        
        do {
            categoryArray = try context.fetch(request)
            
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    


    
}
