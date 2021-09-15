//
//  RecipeFavorite+CoreDataProperties.swift
//  
//
//  Created by Birkyboy on 15/09/2021.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

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
