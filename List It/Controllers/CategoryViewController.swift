//
//  CategoryViewController.swift
//  List It
//
//  Created by Ilhan tasci on 2/22/19.
//  Copyright © 2019 John tasci. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    //copy the one from  to do list, but make it original for its own universal variable
    var categories = [Category]()
    //reads, saves, and destroys data. Communicates with persistent container.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
}
    //Challenge : Failed :( Learned Something :)
    
    //MARK : - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of rows in array
    return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creates a reusable cell and adds it to the tableView at the Index Path.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //name (attribute we created in the datamodel)
        cell.textLabel?.text = categories[indexPath.row].name
        //return the
        return cell
    }
       //MARK: - TableView Delegate Methods
    //this will trigger when we select onw of the cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //using the name of the second main.storyboard
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //where the segue takes us to
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    //MARK: - Data Manipulation Methods
    func saveCategories() {
        //commit our context to opposition container by saying (try context.save). Because it throws then I'm going to hold it inside a do catch block and I'm going to print any errors that it catches
        do{
        try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        //so the tableView updates with our latest data
        tableView.reloadData()
    }
    func loadCategories() {
        //we need to read data from our context and to read data from our context
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        //because it could throw we need to put it in a do and catch block
        do{
        categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
    }
    
    //MARk : - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //store a reference
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
          //where we specify what should happen once the user clicks the button
          //new NSMangementObject
        let newCategory = Category(context: self.context)
        //whatever the user entered in the textField inside alert is going to be the name of the new category.
        newCategory.name =  textField.text!
        //grab reference to the array of category objects by saying self.categories.append(newCategory)
        self.categories.append(newCategory)
        //use self because it's in another closure
        self.saveCategories()
    }
    alert.addAction(action)
    
    alert.addTextField { (field) in
        textField = field
        textField.placeholder = "Add new category"
    }
    present(alert, animated: true, completion: nil )
}
 

        
    
    
}

