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
    
    //This is an array fo item objects.
    var itemArray = [Item]()
    
    //Setup up user defaults constant.
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        //This loads the defaults persistent data into the itemArray.
        
    if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {

            itemArray = items

        }
        
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
    
        let item = itemArray[indexPath.row]
        
        //NOTE: This ensures that the checkmark is attributed to the boolean value.
        //NOTE: This is applying the ternary operator.
        //Essentially shrunken if else.
        //Format: value = condition ? valueIfTrue : ValueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none
    
    //This allocations the cell value based on row value looking up into array.
    cell.textLabel?.text = item.title
    
    //This sends cell vale to table view.
    return cell

}
    //MARK: Table View Delegate Methods
    
    //This allows the cells to have a checkmark.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Essentially this replaces wordy if statement to make it change to opposite value.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //NOTE: This makes sure the cell does not stay selected.
        tableView.deselectRow(at: indexPath, animated: true)
        
         tableView.reloadData()
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
            
                let newItem = Item()
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                
            //Update user defaults. Can add any datat type and then associate a key to return it.
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                
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

