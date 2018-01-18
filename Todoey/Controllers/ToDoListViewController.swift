//
//  ViewController.swift
//  Todoey
//
//  Created by Tom Daniel Home on 14/1/18.
//  Copyright © 2018 Thomas Daniel. All rights reserved.
//

import UIKit
import CoreData

//NOTE: Using a UITableViewController instead of View Controller with table means delegating etc. is all taken care of.
class ToDoListViewController: UITableViewController {
    
    //This is an array fo item objects.
    var itemArray = [Item]()
    //UIApplication class, Shared singleton aobjects which corresponds to the current App, tapping into its delegate.
    //This allows us to tap into the AppDelegate as an object.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Will be optional until it is set
    var selectedCategory : Category? {
        //This runs when a value is set to an optional on declaration.
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
        
//        //The order matters. Keep it this way. It deletes rows.
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        //NOTE: This makes sure the cell does not stay selected.
        tableView.deselectRow(at: indexPath, animated: true)
        
         self.saveItems()
    
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
                
            //Need to use self.context to refer to global context as it is within a closure.
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }

//MARK: Model Manipulation Methods

    func    saveItems() {
    
    do {
        
      try   context.save()
   
    }   catch   {
        
        print("Error saving context \(error)")
        
    }
    
    //This reloads the UITableView view update with the data that has already been added.
     tableView.reloadData()
    
}
    //NOTE: This has a default value if nothing is supplied of Item.fetchRequest()
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //Says we are requesting data in the form of Item.
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //This checks to see if double or single predicate to help load items matching predicate query.
        //Also helps us stop unrapping an optional value.
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
        itemArray = try context.fetch(request)

        } catch {
            print("Error fetching data from context \(error)")
        }
    tableView.reloadData()
}

}

//This is another way you can add delegates to main view controller.
//By slitting it up, it means code can be more easily viewed and edited.
//You must group all protocole methods with protocol.

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //This queries whether title contains the text.
        //Can read up on predicate.
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
    }
    //This repopulates the list with full list when search left.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //Stops search bar being selected or typing in search bar.
            //This manages the queues where work is being ompleted.
            //It assigns jobs to threads. We are assigning search bar to main thread.
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
                
            }
            
        }
        
    }
}


