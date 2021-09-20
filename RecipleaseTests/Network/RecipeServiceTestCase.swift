//
//  RecipeServiceTestCase.swift
//  RecipleaseTests
//
//  Created by Birkyboy on 19/09/2021.
//
@testable import Reciplease
import XCTest
import Alamofire

class RecipeServiceTestCase: XCTestCase {

    var session: Session!
    var sut: RecipeService!
    var expectation: XCTestExpectation!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        session = Session(configuration: configuration)
        sut = RecipeService(session: session)
        expectation = expectation(description: "Expectation")
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        session = nil
    }

    func test_successResponse() {
        MockURLProtocol.data = FakeData.recipeCorrectData

        sut.getRecipes(for: ["lemon, peach, almond"]) { (result) in
            switch result {
            case .success(let recipe):
                XCTAssertEqual(recipe.hits?.first?.recipe?.label, "Peach almond cake")
            case .failure(let error):
                print(error.localizedDescription)
                XCTAssertNil(error)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_givenNoURL_whenRequestionRecipes_thenError() {
        MockURLProtocol.data = FakeData.recipeCorrectData
        sut.apiURL = nil
        sut.getRecipes(for: ["lemon, peach, almond"]) { (result) in
            switch result {
            case .success(let recipe):
                XCTAssertNil(recipe)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.badURL.description)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_givenListOfIngredients_whenRequestionRecipes_thenNoData() {

        MockURLProtocol.data = FakeData.recipeIncorrectData
        sut.getRecipes(for: ["lemon, peach, almond"]) { (result) in
            switch result {
            case .success(let recipe):
                XCTAssertNil(recipe)
                XCTAssertTrue(((recipe.hits?.isEmpty) != nil))
            case .failure(let error):
               XCTAssertNotNil(error)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

