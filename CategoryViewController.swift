//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Martin Dn on 8/6/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Cargo los items desde la memoria
        loadItems()

    }
    
    //MARK: - Cantidad de rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK: - pongo los datos en la celda
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = categoryArray[indexPath.row].name
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = message
                

                
        return cell
    }
    //MARK: - Celda seleccionada
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "goToItems", sender: self)
        
        //saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    //MARK: - ADD new item
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            let newItem = Category(context: self.context)
            
            newItem.name = textField.text!

            
            self.categoryArray.append(newItem)
            
            self.saveItems()
            
                        
        }

        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
    
    
    func saveItems(){
        // Guardo los items en la memoria

        
        do{
            try context.save()
        }catch{
            print("error: \(error)")
        }
        tableView.reloadData()
        
    }
    
    
    // with es el external parameter
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        //let request: NSFetchRequest<Item> = Item.fetchRequest()
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("error \(error)")
        }
        
        tableView.reloadData()
    }


    
  
    
    
    
    
    
    
    
    
}
