//
//  ViewController.swift
//  List It
//
//  Created by Ilhan tasci on 2/13/19.
//  Copyright © 2019 John tasci. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Code for the day","Write articles","Business News"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    //MARK
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    //asks the data source for a cell to insert in a particular location of the table view.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    //TableViewDelagateMethods Shows it in the server
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        //puts a check when selcted
        //deletes it when clicked again
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    ///ADD NEW ITEMS
    @IBAction func addButtonPressed(_ sender: Any) {
        //local variable for every one to use
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new to do list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when the user clicks on add Item button on our UiAlert
            
            //changes the array
            self.itemArray.append(textField.text!)
            //reloads the data to refresh the tableView
            self.tableView.reloadData()
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
