//
//  ViewController.swift
//  DoListApp
//
//  Created by Hammad Hassan on 07/10/2019.
//  Copyright © 2019 Talha. All rights reserved.
//

import UIKit

class doListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
       
        loadItem()
        
//        if let item = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = item
//        }
        
    }

    
    //MARK: - Table View Data Source
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        
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
        
        return cell
    }
    
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
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
            
            let newItem = Item()
            newItem.title = textField.text!
            
           
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
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
        let encoder = PropertyListEncoder()
                  do {
                      
                  let data = try encoder.encode(itemArray)
                      try data.write(to: dataFilePath!)
                  } catch {
                      print("error encoding item array, \(error)")
                  }
        self.tableView.reloadData()
    }

    func loadItem(){
        
      
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            do{
                
            itemArray = try decoder.decode([Item].self, from: data)
                
            }catch{
                print("Error while Decoding, \(error)")
                
            }
        }
            
        
        
    }
    
}

