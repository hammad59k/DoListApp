//
//  CategoryTableViewController.swift
//  DoListApp
//
//  Created by Hammad Hassan on 08/10/2019.
//  Copyright © 2019 Talha. All rights reserved.
//

import UIKit
import CoreData
import  SwipeCellKit

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        saveCategories()
            loadItem()
        
    }

    

    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        cell.delegate = self
        
        return cell
    }
    
    
     //MARK: - TableView Delegates Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! doListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
     //MARK: - Data Manipulation  Methods

    func saveCategories(){
        
        do {
                            
            try context.save()
                          
            } catch {
                           
            print("Error Saving Categories, \(error) ")
                          
    }
        
              tableView.reloadData()
    }
    func loadItem(){

        let request : NSFetchRequest<Category> = Category.fetchRequest()
         do{
       categoryArray = try context.fetch(request)
   
      }catch{
         
        print("Error in Fetching Data from Category,\(error)")
         }
        
        tableView.reloadData()
       }
    
    //MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (Action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
        }
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add New Category"
        }
        present(alert, animated: true, completion: nil)
        
    }
    
}
//MARK: - Swipe Cell Delegate Methods

extension CategoryTableViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.context.delete(self.categoryArray[indexPath.row])
            self.categoryArray.remove(at: indexPath.row)
            print("item deleted")
             self.saveCategories()
           self.tableView.reloadData()
           
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
  
 
}
