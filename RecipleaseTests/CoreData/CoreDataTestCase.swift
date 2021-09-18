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
        sut = CoreDataManager(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        coreDataStack = nil
    }

    // MARK: - Tests
    func test_addRecipe() {
        // When
        let recipe = sut.add(recipe: recipe)
        // Then
        XCTAssertNotNil(recipe)
        XCTAssertTrue(recipe.label == "Chicken stew")
    }

    func test_fetchRecipe() {
        // Given
        let recipe = sut.add(recipe: recipe)
        // When
        let favoriteRecipes = sut.getRecipes()
        XCTAssertNotNil(favoriteRecipes)
        XCTAssertTrue(favoriteRecipes.count == 1)
        XCTAssertTrue(recipe.label == favoriteRecipes.first?.recipe?.label)
    }

    func test_fetchRecipeWithPredicate() {
        // Given
        let recipe = sut.add(recipe: recipe)
        // When
        let favoriteRecipes = sut.getRecipes(with: "Chicken")
        XCTAssertNotNil(favoriteRecipes)
        XCTAssertTrue(favoriteRecipes.count == 1)
        XCTAssertTrue(recipe.label == favoriteRecipes.first?.recipe?.label)
    }

    func test_deleteRecipe() {
        // Given
        sut.add(recipe: recipe)
        let favoriteRecipes = sut.getRecipes()
        XCTAssertNotNil(favoriteRecipes)
        XCTAssertTrue(favoriteRecipes.count == 1)
        XCTAssertTrue(recipe.label == favoriteRecipes.first?.recipe?.label)

        // When
        sut.delete(self.recipe)
        // Then
        let getRecipes = sut.getRecipes()
        XCTAssertNotNil(getRecipes)
        XCTAssertTrue(getRecipes.count == 0)
    }

    func test_recipeAlreadyExist_whenCheckForExisitingRecipe() {
        sut.add(recipe: recipe)
        let recipeExist = sut.verifyRecipeExist(for: recipe)
        XCTAssertTrue(recipeExist)
    }

    func test_recipeDoNotExist_whenAddingAnotherRecipe() {
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

    func test_givenNoRecipes_whenCheckingIfExist_thenError() {
        // When
        let favoriteRecipes = sut.getRecipes()
        XCTAssertNotNil(favoriteRecipes)
        XCTAssertTrue(favoriteRecipes.count == 0)
        // Then
        let recipeExist = sut.verifyRecipeExist(for: nil)
        XCTAssertFalse(recipeExist)
    }
}


