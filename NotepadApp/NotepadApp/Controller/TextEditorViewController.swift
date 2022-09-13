//
//  TextEditorViewController.swift
//  NotepadApp
//
//  Created by Vivek Lakshmanan on 12/09/22.
//

import UIKit
import CoreData

class TextEditorViewController: UIViewController {
    
    //MARK: - Data
    
    static let identifier = "TextEditorViewController"
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 18)!
//        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.08531998843, green: 0.2107496858, blue: 0.2262504995, alpha: 1)
        return label
    }()
    
    var title_text = ""
    
    var display: [Category] = []
    
    var selectedCategory: Item?
    {
        didSet {
            fetchCategory()
        }
}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Text Editor Page
    
    private let textEditor: UITextView = {
        var button = UITextView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.7994263768, green: 0.8243386149, blue: 0.6535012126, alpha: 1)
        button.font = UIFont(name: "Arial", size: 18)!
//        button.placeholder = "Type the Notes here..."
        button.textAlignment = .justified
        button.isScrollEnabled = true
        button.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10);
        button.sizeToFit()
        return button
    }()
    
    //MARK: - View Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9553440213, green: 1, blue: 0.9109973311, alpha: 1)
        titleLabel.text = title_text

        
        self.view.addSubview(textEditor)
        self.view.addSubview(titleLabel)
        configureNavigationforeditor() // Nav Bar
    }
    
    //MARK: - View Will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

//        fetchCategory()
        
        if display.count > 0{
            textEditor.text = display[display.count-1].name
        }
    }
    
    //MARK: - For Title & Notes Editor Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addconstraints() // For Text editor & Title Label
    }
    
    //MARK: - Navigation configuration
    
    func configureNavigationforeditor() {
        self.navigationItem.title = "NOTEPAD APP"
//        self.navigationController?.navigationBar.barTintColor = .systemYellow
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.brown, .font: UIFont(name: "Helvetica-Bold", size: 21)!] // why color change in first page as well???
        
        let saveBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(categorytext))
        
        //MARK: - Attach Button

//        let attachButton = UIBarButtonItem(image: UIImage(systemName: "camera.fill"), style: .done, target: self, action: nil)
        
        let test = UIButton(type: .custom)
        test.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        test.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        //test.addTarget(vw, action: nil, for: .touchUpInside)
        let attachButton = UIBarButtonItem(customView: test)
        attachButton.imageInsets = UIEdgeInsets(top: 0.0, left: -20, bottom: 0, right: 10);
        
        self.navigationItem.rightBarButtonItems = [saveBarButtonItem, attachButton]
    }
    
    //MARK: - Add Image from Gallery
    
    @objc func imageadd() {
        
//        let image = Category(context: context)
        
    }

    //MARK: - Saving & Retriving
    
    @objc func categorytext() {
        
        let catagory = Category(context: context)
        
        catagory.name = textEditor.text
        catagory.parentCategory = self.selectedCategory
        
        do {
            try context.save()
            self.display.append(catagory)
        } catch {
            print("vivek error is in test pragmamark \(error)")
        }
    }
    
    func fetchCategory() {
        
        let request = NSFetchRequest<Category>(entityName: "Category")
        
        let predicate = NSPredicate(format: "parentCategory.title MATCHES %@", selectedCategory!.title!)
        
        request.predicate = predicate
        
        do{
           display = try context.fetch(request)
//            textEditor.text = display[].name
        } catch {
            print(error)
        }
    }
    
    //MARK: - Constraints
    
    private func addconstraints() {
        var constarints = [NSLayoutConstraint]()

        //ADD

        constarints.append(textEditor.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        constarints.append(textEditor.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constarints.append(textEditor.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        constarints.append(textEditor.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70))

//        titleLabel.frame = CGRect(x: 15, y: 120, width: UIScreen.main.bounds.size.width - 20, height: 100)
        constarints.append(titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15))
        constarints.append(titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20))


        //Activate

        NSLayoutConstraint.activate(constarints)
    }

}
