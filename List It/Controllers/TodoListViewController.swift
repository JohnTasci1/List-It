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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        print(dataFilePath)
        
        loadItems()
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
        
        saveItems()

       
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
            
           self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            //allows the user to type whatever they want on their to do list
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
}
//function to save items
func saveItems() {
    //encoder = convert (information or an instruction) into a particular form.
    let encoder = PropertyListEncoder()
    
    do  {
        let data = try encoder.encode(itemArray)
        try data.write(to: dataFilePath!)
    } catch {
        print("Error encoding the itemArray, \(error)")
    }
    
    self.tableView.reloadData()
//function to load items
}
func loadItems() {
    //decoding = convert (a coded message) into intelligible language.
    if let data = try? Data(contentsOf: dataFilePath!) {
        let decoder = PropertyListDecoder()
        do  {
        itemArray = try decoder.decode([Item].self , from: data)
        } catch {
            print("Error decodeing item array \(error)")
            }
        }
    }
}
