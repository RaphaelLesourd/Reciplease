//
//  CoreDataStackFake.swift
//  RecipleaseTests
//
//  Created by Birkyboy on 15/09/2021.
//

@testable import Reciplease
import Foundation
import CoreData

class TestCoreDataStack: AppDelegate {

    override init() {
        super.init()

        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        
        let container = NSPersistentContainer(name: "RecipeFavoriteDataModel")
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        persistentContainer = container
    }
}
