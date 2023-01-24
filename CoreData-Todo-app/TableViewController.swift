//
//  TableViewController.swift
//  TestApp
//
//  Created by Kamil Caglar on 16/10/2022.
//

import UIKit
import CoreData

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return people.count
  }

  func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let person = people[indexPath.row]
      let selfSizingCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelfSizingTableViewCell
      selfSizingCell.cellLabelText.text = person.value(forKeyPath: "text") as? String
      return selfSizingCell
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

      let editAction = UIContextualAction(style: .normal, title: "Edit") {_, _, _ in
        print("Edit Button")

        let person = self.people[indexPath.row]
        var personMessage = person.value(forKey: "text") as? String
        let alert = UIAlertController(title: "Change the note", message: personMessage, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            guard let textField = alert.textFields?.first else {
                return
            }
            if let textToEdit = textField.text{
                if textToEdit.count == 0{
                    return
                }
                personMessage = textToEdit
                //self.editName(editName: textToEdit, indexPath: indexPath)
                //self.tableView.reloadData()
                self.tableView?.reloadRows(at: [indexPath], with: .automatic)
            } else {
                return
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel",
                                            style: .cancel)
        alert.addTextField()
        guard let textField = alert.textFields?.first else{
            return
        }
        textField.placeholder = "Change this message"
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    editAction.backgroundColor = .systemTeal
    let share = UIContextualAction(style: .normal , title: "Share") {_, _, _ in
        let person = self.people[indexPath.row]
        let textToShare = person.value(forKey: "text") as? String
        let shareSheetVC = UIActivityViewController(activityItems:[textToShare!], applicationActivities: nil)
        self.present(shareSheetVC, animated: true)
    }
    share.backgroundColor = .systemIndigo
    let delete = UIContextualAction(style: .destructive, title: "Delete") {_, _, _ in
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        // 1
        let managedContext =
        appDelegate.persistentContainer.viewContext

        // Remove the people from the CoreData
        appDelegate.persistentContainer.viewContext.delete(self.people[indexPath.row])
        // Save Changes
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        // Remove row from TableView
        self.people.remove(at: indexPath.row)
        self.tableView.reloadData()

    }
    // SWIPE TO LEFT CONFIGURATION
    let swipeConfiguration = UISwipeActionsConfiguration(actions: [share, delete, editAction])
    return swipeConfiguration
}




}
