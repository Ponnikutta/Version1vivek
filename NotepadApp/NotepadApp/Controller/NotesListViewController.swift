//
//  ViewController.swift
//  NotepadApp
//
//  Created by Vivek Lakshmanan on 11/09/22.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController, UITableViewDelegate {
    
    //MARK: - Data
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Table View
        
    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        return tableview
    }()
    
    //MARK: - Floating Button
    
    private let floatingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.backgroundColor = .systemPink
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    //MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView) // for table
        
        loadItems()
        
//      tableView.backgroundColor = .systemCyan // Table View Color
        tableView.delegate = self // Inorder to intimate the changes like clicking
        tableView.dataSource = self // For populating data
        
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside) // To create new Notes
        
        configureNavigation() // Nav Bar
    }
    
    //MARK: - For Table Layout & Floating Button
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true // for position
        floatingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true // for position
        
        tableView.frame = view.bounds
    }
    
    //MARK: - Add New Notes
    
    @objc private func didTapButton() {
        
        var textField = UITextField()
    
        let alert = UIAlertController(title: "Add Title", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Tyepo"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Save Items
    
    func saveItems() {

        do{
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
    }

    
    //MARK: - Load Items
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from contect \(error)")
        }
    }
    
    //MARK: - Navigation configuration
    
    func configureNavigation() {
        self.navigationItem.title = "NOTEPAD APP"
//        self.navigationController?.navigationBar.barTintColor = .systemYellow
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemCyan, .font: UIFont(name: "Helvetica-Bold", size: 21)!]
    }
    
}

//MARK: - Tableview Datasource

extension NotesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Table View Delegate Method
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        let mainVC = TextEditorViewController()
        self.navigationController?.pushViewController(mainVC, animated: true)
        mainVC.title_text = itemArray[indexPath.row].title!
        
        if let indexPath = tableView.indexPathForSelectedRow {
            mainVC.selectedCategory = itemArray[indexPath.row]
        }

        saveItems()
//        tableView.deselectRow(at: indexPath, animated: true)

    }
    
}
