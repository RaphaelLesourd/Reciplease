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

    private var session: Session!
    private var sut: RecipeService!
    private let url = URL(string: "myDefaultURL")!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        session = Session.init(configuration: configuration)
        sut = RecipeService(session: session)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        session = nil
    }

    func test_givenListOfIngredients_whenRequestingRecipes_thenSuccessResponse() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.recipeCorrectData)
        }
        
       sut.getRecipes(for: ["lemon, peach, almond"]) { (result) in
            switch result {
            case .success(let recipe):
                XCTAssertEqual(recipe.hits?.first?.recipe?.label, "Peach almond cake")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_givenListOfIngredients_whenRequestReturnBadData_thenDataError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.recipeIncorrectData)
        }

        sut.getRecipes(for: ["lemon, peach, almond"]) { (result) in
            switch result {
            case .success(let recipe):
                XCTAssertNil(recipe)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_givenEmptyIngredients_whenRequestionRecipes_thenEmptyListError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.emptyRecipeCorrectData)
        }

        sut.getRecipes(for: []) { (result) in
            switch result {
            case .success(let recipe):
                XCTAssertNil(recipe)
            case .failure(let error):
                XCTAssertEqual(error as! ApiError, ApiError.noData)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_givenNoIngredients_whenRequestionRecipes_thenError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        sut.getRecipes(for: nil) { (result) in
            switch result {
            case .success(let recipe):
                XCTAssertNil(recipe)
            case .failure(let error):
                XCTAssertEqual(error as! ApiError, ApiError.noInputData)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

