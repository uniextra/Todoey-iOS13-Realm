//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    
    var selectedCategory: Category?{
        // Se ejecuta cuando se crea la variable
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Cargo los items desde la memoria
        loadItems()

    }
    
    //MARK: - Cantidad de rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - pongo los datos en la celda
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = itemArray[indexPath.row].title
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = message
                
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
                
        return cell
    }
    //MARK: - Celda seleccionada
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // borrar
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - ADD new item
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            self.tableView.reloadData()
            
        }

        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "New alert"
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
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        }else{
            request.predicate = categoryPredicate
        }
        
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("error \(error)")
        }
        
        tableView.reloadData()
    }
    

    
}
//MARK: - UISearchBar
extension TodoListViewController: UISearchBarDelegate{
    


    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        let request: NSFetchRequest<Item> = Item.fetchRequest()

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
                
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                
        loadItems(with: request, predicate: predicate)
        
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()  // Quito el teclado una vez ya escribi
            }
            
        }
    }
    
    
}
