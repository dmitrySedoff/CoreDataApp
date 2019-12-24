//
//  TaskListViewController.swift
//  CoreDataApp
//
//  Created by Alexey Efimov on 23.12.2019.
//  Copyright © 2019 Alexey Efimov. All rights reserved.
//

import UIKit
import CoreData


class TaskListViewController: UITableViewController {
    
    private let cellID = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        StorageManager.shared.fetchData()
    }

    private func setupView() {
        view.backgroundColor = .white
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        title = "Task list"
        
        // Set large title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = UIColor(
                displayP3Red: 21/255,
                green: 101/255,
                blue: 192/255,
                alpha: 194/255
            )
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            
            // Add button to navigation bar
            navigationItem.leftBarButtonItem = editButtonItem
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(addNewTask))
            
            navigationController?.navigationBar.tintColor = .white
        }
    }
    
    @objc private func addNewTask() {
        showAlert(title: "New task", message: "What do you want to do?")
    }
}

// MARK: - Table View Data Source
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        StorageManager.shared.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let task = StorageManager.shared.tasks[indexPath.row]
        cell.textLabel?.text = task.name
        
        return cell
    }
    
// Удаление строк
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.shared.delete(from: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - Alert controller
extension TaskListViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else {
                print("The text field is empty")
                return
            }
            StorageManager.shared.save(task)
            let cellIndex = IndexPath(row: StorageManager.shared.tasks.count - 1, section: 0)
            self.tableView.insertRows(at: [cellIndex], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
