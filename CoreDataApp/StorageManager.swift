//
//  StorageManager.swift
//  CoreDataApp
//
//  Created by iD on 24.12.2019.
//  Copyright © 2019 Alexey Efimov. All rights reserved.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var tasks: [Task] = []
    
    
    // MARK: - Work with Core Data
    
    func save(_ taskName: String) {
        guard let entityDescription = NSEntityDescription.entity(
            forEntityName: "Task",
            in: persistentContainer.viewContext
            )
            else { return }
        
        let task = NSManagedObject(entity: entityDescription, insertInto: persistentContainer.viewContext) as! Task
        task.name = taskName
        
        do {
            try persistentContainer.viewContext.save()
            tasks.append(task)
        } catch let error {
            print(error)
        }
    }
    
    func delete(from index: IndexPath) {
        
        do {
            let taskName = StorageManager.shared.tasks.remove(at: index.row)
            persistentContainer.viewContext.delete(taskName as NSManagedObject)
            try StorageManager.shared.persistentContainer.viewContext.save()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        
    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
