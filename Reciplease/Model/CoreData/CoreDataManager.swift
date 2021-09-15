//
//  CoreDataManager.swift
//  Reciplease
//
//  Created by Birkyboy on 13/09/2021.
//

import Foundation
import CoreData

class CoreDataManager {

// MARK: - Properties
let managedObjectContext: NSManagedObjectContext
let coreDataStack: CoreDataStack

// MARK: - Initializers
public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
    self.managedObjectContext = managedObjectContext
    self.coreDataStack = coreDataStack
}
}

// MARK: - Public
extension CoreDataManager {

    @discardableResult
    public func add(recipe: RecipeClass) -> RecipeFavorite? {
        let favoriteRecipe = RecipeFavorite(context: managedObjectContext)
        favoriteRecipe.timestamp       = Date()
        favoriteRecipe.label           = recipe.label
        favoriteRecipe.image           = recipe.image
        favoriteRecipe.url             = recipe.url
        favoriteRecipe.ingredientLines = recipe.ingredientLines
        favoriteRecipe.totalTime       = Int32(recipe.totalTime ?? 0)
        favoriteRecipe.yield           = Int32(recipe.yield ?? 0)

        coreDataStack.saveContext(managedObjectContext)
        return favoriteRecipe
    }

    public func getRecipes(completion: @escaping (Result<[Hit], CoredataError>) -> Void) {
        let request: NSFetchRequest<RecipeFavorite> = RecipeFavorite.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]

        var favoriteRecipes: [Hit] = []
        do {
            let recipes = try managedObjectContext.fetch(request)
            recipes.forEach { favoriteRecipes.append(Hit(recipe: RecipeClass(label: $0.label,
                                                                             image: $0.image,
                                                                             url: $0.url,
                                                                             yield: Int($0.yield),
                                                                             ingredientLines: $0.ingredientLines,
                                                                             totalTime: Int($0.totalTime))))}
            completion(.success(favoriteRecipes))
        } catch {
            completion(.failure(.retreiveFailed))
        }
    }

    public func delete(_ recipe: RecipeClass) {
        let request: NSFetchRequest<RecipeFavorite> = RecipeFavorite.fetchRequest()
        if let recipeURL = recipe.url {
            request.predicate = NSPredicate(format: "url == %@", "\(recipeURL)")
        }

        let result = try? managedObjectContext.fetch(request)
        if let resultData = result {
            for object in resultData {
                managedObjectContext.delete(object)
            }
        }
        coreDataStack.saveContext(managedObjectContext)
    }

    // Verify
    func verifyRecipeExist(for recipe: RecipeClass) -> Bool {
        let request: NSFetchRequest<RecipeFavorite> = RecipeFavorite.fetchRequest()
        if let recipeURL = recipe.url {
            request.predicate = NSPredicate(format: "url == %@", "\(recipeURL)")
        }
        let recipes = try? managedObjectContext.fetch(request)
        return !(recipes?.isEmpty ?? false)
    }
}
