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
   
    // MARK: - Initializers
    public init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
}

// MARK: - Extension CRUD
extension CoreDataManager {

    /// Add a recipe to coredate
    /// - Parameter recipe: Pass in a recipe of type RecipeClass
    /// - Returns: A RecipeFavorite object of type NSManagedObject. (Used if the added object needs to be manipulated)
    public func add(recipe: RecipeClass) {
        let favoriteRecipe = RecipeFavorite(context: managedObjectContext)
        favoriteRecipe.timestamp       = Date()
        favoriteRecipe.label           = recipe.label
        favoriteRecipe.image           = recipe.image
        favoriteRecipe.url             = recipe.url
        favoriteRecipe.ingredientLines = recipe.ingredientLines
        favoriteRecipe.totalTime       = Int32(recipe.totalTime ?? 0)
        favoriteRecipe.yield           = Int32(recipe.yield ?? 0)
        try? saveContext()
    }
    /// Get recipes from coredata.
    /// - Parameters:
    ///   - name: Word(s) part if the recipe label. if not empty a predicate cotaining the name is used to filter recipes.
    ///   - ascending: Boolean to set wether if recipes are shown in ascending or descending order.
    /// - Throws: An error of type NSError.
    /// - Returns: Array of recipes of type Hit.
    public func getRecipes(with name: String = "", ascending: Bool = false) throws -> [RecipeClass] {
        let request: NSFetchRequest<RecipeFavorite> = RecipeFavorite.fetchRequest()
        if name != "" {
            request.predicate = NSPredicate(format: "label CONTAINS[cd] %@", name)
        }
        request.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: ascending)
        ]
        var favoriteRecipes: [RecipeClass] = []
        do {
            let recipes = try managedObjectContext.fetch(request)
            recipes.forEach { favoriteRecipes.append(RecipeClass(label: $0.label,
                                                                 image: $0.image,
                                                                 url: $0.url,
                                                                 yield: Int($0.yield),
                                                                 ingredientLines: $0.ingredientLines,
                                                                 totalTime: Int($0.totalTime)))}
        } catch { throw error }
        return favoriteRecipes
    }
    /// Delete recipe from coredata.
    /// - Parameter recipe: Pass in the recipe to delete
    /// - Throws: An error of type NSError
    public func delete(_ recipe: RecipeClass?) throws {
        let request: NSFetchRequest<RecipeFavorite> = RecipeFavorite.fetchRequest()
        if let recipeURL = recipe?.url {
            request.predicate = NSPredicate(format: "url == %@", "\(recipeURL)")
            do {
                let result = try managedObjectContext.fetch(request)
                for object in result {
                    managedObjectContext.delete(object)
                }
                try? saveContext()
            } catch { throw error }
        }
    }
    /// Verity if the recipe is already in coredata.
    /// - Parameter recipe: Pass in the recipe to check.
    /// - Returns: Boolean if in coredata or not.
    func verifyRecipeExist(for recipe: RecipeClass?) -> Bool {
        let request: NSFetchRequest<RecipeFavorite> = RecipeFavorite.fetchRequest()
        guard  let recipeURL = recipe?.url else { return false }
        request.predicate = NSPredicate(format: "url == %@", "\(recipeURL)")
        guard let recipes = try? managedObjectContext.fetch(request) else { return false }
        return !recipes.isEmpty
    }
    
    // MARK: - Core Data Saving support
    private func saveContext() throws {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch { throw error }
        }
    }
}
