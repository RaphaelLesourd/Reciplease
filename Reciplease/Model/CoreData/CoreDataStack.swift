//
//  File.swift
//  Reciplease
//
//  Created by Birkyboy on 15/09/2021.
//

import Foundation
import CoreData

open class CoreDataStack {
    public static let modelName = "Reciplease"

    public static let model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    public init() {
    }

    public lazy var context: NSManagedObjectContext = {
        return storageContainer.viewContext
    }()

    public lazy var storageContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    public func saveContext(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

}
