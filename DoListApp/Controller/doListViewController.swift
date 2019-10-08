//
//  ViewController.swift
//  DoListApp
//
//  Created by Hammad Hassan on 07/10/2019.
//  Copyright © 2019 Talha. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit
class doListViewController: UITableViewController{

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItem()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 65.0
    
        
       
       
   
        
//        if let item = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = item
//        }
        
    }

    
    //MARK: - TableView Data Source Methods
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath) as! SwipeTableViewCell
        
        
        let item = itemArray[indexPath.row]
        
        
        cell.textLabel?.text = item.title
        
//        Ternory Operator
//        value = condition ? valueIfTrue : valueIfFalse
        
//        cell.accessoryType = item.done == true ? .checkmark : .none
        
        if item.done == true {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        cell.delegate = self
        return cell
    }
    
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
      itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
//       
        
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }else {
//            itemArray[indexPath.row].done = false
//        }
        
        saveItem()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (Action) in
            // What will happen when user pressed Add button on UIAlert
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
           

            self.itemArray.append(newItem)
            
            
            self.saveItem()
            
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
          
            
            

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manupulation Methods
    
    func saveItem()
    {
        
                  do {
                      
                   try context.save()
                    
                  } catch {
                     
                    print("Error Saving COntext, \(error) ")
                    
                  }
        self.tableView.reloadData()
    }

    func loadItem(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate :NSPredicate? = nil ){

      
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@ ", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
       
       
        
        do{
       itemArray = try context.fetch(request)
        
        }catch{
            print("Error in Fetching Data from context,\(error)")
        }
     self.tableView.reloadData()
    }
   
    
   
}

//MARK: - SearchBar Methods

extension doListViewController : UISearchBarDelegate {
    
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
      let request : NSFetchRequest<Item> = Item.fetchRequest()
                          
                          let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
                          
                          request.predicate = predicate
                          
                          let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
                          
                          request.sortDescriptors = [sortDescriptor]
                          
                          do{
                              itemArray = try context.fetch(request)
                              
                          }catch{
                              print("Error in Fetching Data from context,\(error)")
                          }
                          tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
//MARK: - Swipe Cell Delegate Methods

extension doListViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.context.delete(self.itemArray[indexPath.row])
            self.itemArray.remove(at: indexPath.row)
            print("item deleted")
             self.saveItem()
           self.tableView.reloadData()
           
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
  
 
}
