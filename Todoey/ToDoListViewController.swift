//
//  ViewController.swift
//  Todoey
//
//  Created by Tom Daniel Home on 14/1/18.
//  Copyright © 2018 Thomas Daniel. All rights reserved.
//

import UIKit


//NOTE: Using a UITableViewController instead of View Controller with table means delegating etc. is all taken care of.
class ToDoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: Tableview Data Source Methods
    
    //First input the number of rows. NOTE: Must inlude overide.
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    //This ensures that the array size will match the number of rows in the in the UITableView.
    return itemArray.count
    
}
    //This allocates the values to the UITableView. NOTE: Must inlude overide.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    //This lets cell = the cells in UITableView.
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
    //This allocations the cell value based on row value looking up into array.
    cell.textLabel?.text = itemArray[indexPath.row]
    
    //This sends cell vale to table view.
    return cell

}
    //MARK: Table View Delegate Methods
    
    //This allows the cells to have a checkmark.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        } else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //NOTE: This makes sure the cell does not stay selected.
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    //MARK: Add New Items
    
    //This gives the add new items buttons with calling alert box.
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item:", message: "", preferredStyle: .alert)
        
        //What will happen when user clicks add item button on UI Alert.
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            //This is error checking code to prevent no submission of an empty to do.
            if textField.text == "" {
            
            } else {
                
            self.itemArray.append(textField.text!)
            
            //This reloads the UITableView view update with the data that has already been added.
            self.tableView.reloadData()
            
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
        
    }

