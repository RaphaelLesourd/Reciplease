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

    func test_givenStringOfIngredientsSeparatedByComma_WhenAdding_ThenArrayOfIngredients() {
        // Given
        let string = "lemon,carrots,onions,cheese"
        // When
        sut?.addIngredient(for: string)
        // Then
        XCTAssertEqual(sut?.ingredients, ["carrots", "cheese", "lemon", "onions"])
    }

    func test_givenStringOfIngredientsSeparatedByComma_WhenAddingWithEmptySpaces_ThenEmptySpacesDropped() {
        // Given
        let string = "lemon,carrots,,onions,cheese,"
        // When
        sut?.addIngredient(for: string)
        // Then
        XCTAssertEqual(sut?.ingredients, ["carrots", "cheese", "lemon", "onions"])
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
