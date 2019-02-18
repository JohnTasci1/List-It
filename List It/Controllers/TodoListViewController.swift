//
//  ViewController.swift
//  List It
//
//  Created by Ilhan tasci on 2/13/19.
//  Copyright © 2019 John tasci. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = Item()
        newItem.title = "Code"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem.title = "Read"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem.title = "Bussiness"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ListItArray") as? [Item]{
            itemArray = items
        }
    }
    //MARK
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    //asks the data source for a cell to insert in a particular location of the table view.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        //Ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
       
        
        
        return cell
        
    }
    //TableViewDelagateMethods Shows it in the server
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    ///ADD NEW ITEMS
    @IBAction func addButtonPressed(_ sender: Any) {
        //local variable for every one to use
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new to do list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when the user clicks on add Item button on our UiAlert
            //always add self in a closure
            //changes the array
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            //reloads the data to refresh the tableView
            self.tableView.reloadData()
            
            self.defaults.set(self.itemArray, forKey: "ListItArray")
        }
        
        alert.addTextField { (alertTextField) in
            //allows the user to type whatever they want on their to do list
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
}

}

