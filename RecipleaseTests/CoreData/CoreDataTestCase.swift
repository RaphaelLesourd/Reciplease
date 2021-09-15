//
//  CoreDataTestCase.swift
//  RecipleaseTests
//
//  Created by Birkyboy on 15/09/2021.
//
@testable import Reciplease
import CoreData
import XCTest

class CoreDataTestCase: XCTestCase {

    var sut: CoreDataManager!
    var coreDataStack: CoreDataStack!
    private let recipe = RecipeClass(label: "Chicken stew",
                                     image: "",
                                     url: "recipe url",
                                     yield: nil,
                                     ingredientLines: [],
                                     totalTime: nil)

    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        sut = CoreDataManager(managedObjectContext: coreDataStack.context, coreDataStack: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        coreDataStack = nil
    }

    // MARK: - Success
    func testAddRecipe() {
        // When
        let recipe = sut.add(recipe: recipe)
        // Then
        XCTAssertNotNil(recipe, "Report should not be nil")
        XCTAssertTrue(recipe?.label == "Chicken stew")
    }

    func testFetchRecipe() {
        // Given
        let recipe = sut.add(recipe: recipe)
        // When
        sut.getRecipes() { result in
            // Then
            switch result {
                case .success(let favoriteRecipes):
                    XCTAssertNotNil(favoriteRecipes)
                    XCTAssertTrue(favoriteRecipes.count == 1)
                    XCTAssertTrue(recipe?.label == favoriteRecipes.first?.recipe?.label)
                case .failure(let error):
                    XCTAssertNil(error)
            }
        }
    }

    func testDeleteRecipe() {
        // Given
        sut.add(recipe: recipe)
        sut.getRecipes() { result in
            switch result {
                case .success(let favoriteRecipes):
                    XCTAssertNotNil(favoriteRecipes)
                    XCTAssertTrue(favoriteRecipes.count == 1)
                    XCTAssertTrue(self.recipe.label == favoriteRecipes.first?.recipe?.label)
                case .failure(let error):
                    XCTAssertNil(error)
            }
        }

        // When
        sut.delete(self.recipe)
        // Then
        sut.getRecipes() { result in
            switch result {
                case .success(let favoriteRecipes):
                    XCTAssertNotNil(favoriteRecipes)
                    XCTAssertTrue(favoriteRecipes.count == 0)
                case .failure(let error):
                    XCTAssertNil(error)
            }
        }
    }

    func testRecipeAlreadyExist_WhenCheckForExisitingRecipe() {
        sut.add(recipe: recipe)
        let recipeExist = sut.verifyRecipeExist(for: recipe)
        XCTAssertTrue(recipeExist)
    }

    func testRecipeDoNotExist_WhenAddingAnotherRecipe() {
        sut.add(recipe: recipe)
        let otherRecipe = RecipeClass(label: "Green curry",
                                      image: "",
                                      url: "green curry recipe url",
                                      yield: nil,
                                      ingredientLines: [],
                                      totalTime: nil)
        let recipeExist = sut.verifyRecipeExist(for: otherRecipe)
        XCTAssertFalse(recipeExist)
    }
}
