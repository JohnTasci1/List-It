//
//  ViewController.swift
//  List It
//
//  Created by Ilhan tasci on 2/13/19.
//  Copyright © 2019 John tasci. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    //when we call load items we're certain that we've alread got a value for our selected
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    
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
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            //category is available to us because we created thar relationship that points to the category entity.
            newItem.parentCategory = self.selectedCategory
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
  
    
    do  {
        try context.save()
    } catch {
      print("Error saving context \(error)")
    }
    
    tableView.reloadData()
//function to load items
}
                                                                        //now it has a default value and makes the loadItems() works on further uses. ? for optional only when needed
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
    
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //using optional binding and making sure we never wunwrapp a nill value
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
// MARK: -Search Bar Methods
//extends and makes it more organized. Narrows down debugging
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //NSPredicate = specify how data should be fetched or filtered
        //Realm NSPredicate cheat sheet
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with : request, predicate: predicate)
        
          }
    //makes the searchBar so you could search up what you want
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
        }
    }
}
