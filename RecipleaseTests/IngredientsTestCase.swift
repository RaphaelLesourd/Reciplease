//
//  IngredientsTestCase.swift
//  RecipleaseTests
//
//  Created by Birkyboy on 06/09/2021.
//
@testable import Reciplease
import XCTest

class IngredientsTestCase: XCTestCase {

    var sut: IngredientDataSource?

    override func setUp() {
        super.setUp()
        sut = IngredientDataSource()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - Errors
    func test_givenAnIngredienThatExist_WhenAddingIngredient_ThenAlreadyExistError() {
        // Given
        let string = "lemon"
        // When
        sut?.addIngredient(for: string) { _ in }
        sut?.addIngredient(for: string) { error in
            // Then
            XCTAssertEqual(error?.description, IngredientError.alreadyExist(ingredientName: string).description)
        }
    }

    func test_givenAnEmptyString_WhenAddingIngredient_ThenNoNameError() {
        // Given
        let string = ""
        // When
        sut?.addIngredient(for: string) { error in
            // Then
            XCTAssertEqual(error?.description, IngredientError.noName.description)
        }
    }

    // MARK: - Success
    func test_givenStringOfIngredientsSeparatedByComma_WhenAdding_ThenArrayOfIngredients() {
        // Given
        let string = "lemon,carrots,onions,cheese"
        // When
        sut?.addIngredient(for: string) { _ in }
        // Then
        XCTAssertEqual(sut?.ingredients, ["Carrots", "Cheese", "Lemon", "Onions"])
    }

    func test_givenStringOfIngredientsSeparatedByComma_WhenAddingWithEmptySpaces_ThenEmptySpacesDropped() {
        // Given
        let string = "lemon,carrots,,onions,cheese,"
        // When
        sut?.addIngredient(for: string) { _ in }
        // Then
        XCTAssertEqual(sut?.ingredients, ["Carrots", "Cheese", "Lemon", "Onions"])
    }

    func test_givenArrayOfIngredients_WhenDeletedAnIngredientByName_ThenIngredientRemoved() {
        // Given
        sut?.ingredients = ["carrots", "cheese", "lemon", "onions"]
        // When
        sut?.deleteIngredient(with: "carrots")
        // Then
        XCTAssertEqual(sut?.ingredients, ["cheese", "lemon", "onions"])
    }

    func test_givenArrayOfIngredients_WhenDeletedAllIngredients_ThenArrayEmpty() {
        // Given
        sut?.ingredients = ["carrots", "cheese", "lemon", "onions"]
        // When
        sut?.clearIngredientList()
        // Then
        XCTAssertEqual(sut?.ingredients, [])
    }
}
