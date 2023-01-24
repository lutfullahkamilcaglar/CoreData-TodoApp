//
//  ViewController.swift
//  TestApp
//
//  Created by Kamil Caglar on 10/10/2022.
//

import UIKit
import CoreData
 

class ViewController: UIViewController, UITableViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        let buttonImage = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44, weight: .medium))
        addButton.setImage(buttonImage, for: .normal)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      //1
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      //2
        
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Note")
      
      //3
      do {
        people = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }

    
    @IBAction func addButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Note",
                                      message: "Enter the note",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else {
                return
            }
            save(nameValue: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
        
        
    }
    
    func save(nameValue: String) {
        if nameValue.isEmpty {
            print("Name value cannot be empty.")
            return
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(nameValue, forKeyPath: "text")
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

//    func save(nameValue: String) {
//
//        guard let appDelegate =
//                UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//
//        // 1
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        // 2
//        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
//
//
//        let person = NSManagedObject(entity: entity, insertInto: managedContext)
//
//        // 3
//        person.setValue(nameValue, forKeyPath: "text")
//
//        // 4
//        do {
//            try managedContext.save()
//            people.append(person)
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
    

    func editName(editName: String, indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        do {
            let notes = try managedContext.fetch(fetchRequest)
            let note = notes[indexPath.row]
            note.setValue(editName, forKey: "text")
            try managedContext.save()
            people[indexPath.row] = note
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}

