//
//  RecipeFavorite.swift
//  Reciplease
//
//  Created by Birkyboy on 11/09/2021.
//

import Foundation
import CoreData

@objc(RecipeFavorite)
public class RecipeFavorite: NSManagedObject {}

extension RecipeFavorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeFavorite> {
        return NSFetchRequest<RecipeFavorite>(entityName: "RecipeFavorite")
    }
    @NSManaged public var image: String?
    @NSManaged public var ingredientLines: [String]?
    @NSManaged public var label: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var totalTime: Int32
    @NSManaged public var url: String?
    @NSManaged public var yield: Int32
}

extension RecipeFavorite : Identifiable {}
