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
    var testCoreDataStack: TestCoreDataStack!
    private let recipe = RecipeClass(label: "Chicken stew",
                                     image: "",
                                     url: "recipe url",
                                     yield: nil,
                                     ingredientLines: [],
                                     totalTime: nil)

    override func setUp() {
        super.setUp()
        testCoreDataStack = TestCoreDataStack()
        sut = CoreDataManager(managedObjectContext: testCoreDataStack.persistentContainer.viewContext)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        testCoreDataStack = nil
    }

    // MARK: - Tests
    func test_addRecipe() {
        // When
        sut.add(recipe: recipe)
        // Then
        XCTAssertNotNil(recipe)
        XCTAssertTrue(recipe.label == "Chicken stew")
    }

    func test_fetchRecipe() {
        // Given
        sut.add(recipe: recipe)
        // When
        do {
            let favoriteRecipes = try sut.getRecipes()
            XCTAssertNotNil(favoriteRecipes)
            XCTAssertTrue(favoriteRecipes.count == 1)
            XCTAssertTrue(recipe.label == favoriteRecipes.first?.label)
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func test_fetchRecipeWithPredicate() {
        // Given
        sut.add(recipe: recipe)
        // When
        do {
            let favoriteRecipes = try sut.getRecipes(with: "Chicken")
            XCTAssertNotNil(favoriteRecipes)
            XCTAssertTrue(favoriteRecipes.count == 1)
            XCTAssertTrue(recipe.label == favoriteRecipes.first?.label)
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func test_deleteRecipe() {
        // Given
        sut.add(recipe: recipe)
        do {
            let favoriteRecipes = try sut.getRecipes()
            XCTAssertNotNil(favoriteRecipes)
            XCTAssertTrue(favoriteRecipes.count == 1)
            XCTAssertTrue(recipe.label == favoriteRecipes.first?.label)
        } catch {
            XCTAssertNotNil(error)
        }

        // When
        do {
            try sut.delete(self.recipe)
        } catch let error {
            XCTAssertNotNil(error)
        }

        // Then
        do {
            let favoriteRecipes = try sut.getRecipes()
            XCTAssertNotNil(favoriteRecipes)
            XCTAssertTrue(favoriteRecipes.count == 0)
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func test_deleteRecipe_whenNoRecipePassed() {
        // Given
        sut.add(recipe: recipe)
        do {
            let favoriteRecipes = try sut.getRecipes()
            XCTAssertNotNil(favoriteRecipes)
            XCTAssertTrue(favoriteRecipes.count == 1)
            XCTAssertTrue(recipe.label == favoriteRecipes.first?.label)
        } catch {
            XCTAssertNotNil(error)
        }

        sut.managedObjectContext.name = nil
        // When
        do {
            try sut.delete(nil)
        } catch let error {
            // Then
            XCTAssertNotNil(error)
        }
    }

    func test_recipeAlreadyExist_whenCheckForExisitingRecipe_thenReturnTrue() {
        sut.add(recipe: recipe)
        let recipeExist = sut.verifyRecipeExist(for: recipe)
        XCTAssertTrue(recipeExist)
    }

    func test_recipeDoNotExist_whenAddingAnotherRecipe_thenReturnFalse() {
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

    func test_givenNoRecipes_whenCheckingIfExist_thenReturnFalse() {
        // When
        do {
            let favoriteRecipes = try sut.getRecipes()
            XCTAssertNotNil(favoriteRecipes)
            XCTAssertTrue(favoriteRecipes.count == 0)
        } catch {
            XCTAssertNotNil(error)
        }
        // Then
        let recipeExist = sut.verifyRecipeExist(for: nil)
        XCTAssertFalse(recipeExist)
    }
}


