//
//  WeatherViewModelTest.swift
//  WeatherTests
//
//  Created by Anh Tran on 20/09/2021.
//

import XCTest
import Combine
@testable import Weather
class WeatherViewModelTest: XCTestCase {

    var weatherServiceMock: WeatherServiceMock!
    var weatherConfigMock: WeatherConfigType!
    var viewModel: WeatherViewModel!
    
    private var cancellables: [AnyCancellable] = []
    override func setUpWithError() throws {
        weatherServiceMock = WeatherServiceMock()
        weatherConfigMock = WeatherConfigMock()
        viewModel = WeatherViewModel(service: weatherServiceMock,
                                     config: weatherConfigMock)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_search_weather_should_trigger_empty_state_when_init() {
        //Given
        let search = PassthroughSubject<String, Never>()
        
        let input = WeatherViewModelInput(loadView: .just(()),
                                          search: search.eraseToAnyPublisher())
        //When
        let expectation = self.expectation(description: "movies")
        var state: SearchWeatherState?
        let output = viewModel.transform(input: input)
        output.weatherSearchOutput.sink { value in
            state = value
            expectation.fulfill()
        }.store(in: &cancellables)
        
        //Then
        waitForExpectations(timeout: 1.0, handler: nil)
        if case .empty = state {
            XCTAssertTrue(true)
        }else{
            XCTAssertTrue(false,"Weather should initial as empty state")
        }
    }
    
    func test_search_weather_should_search_state_when_triger_search() {
        //Given
        let search = PassthroughSubject<String, Never>()
        let input = WeatherViewModelInput(loadView: .just(()),
                                          search: search.eraseToAnyPublisher())
        //When
        let expectation = self.expectation(description: "movies")
        var state: SearchWeatherState?
        let output = viewModel.transform(input: input)
        output.weatherSearchOutput.sink { value in
            guard case .loaded = value else { return }
            state = value
            expectation.fulfill()
        }.store(in: &cancellables)
        
        search.send("Saigon")
        
        //Then
        waitForExpectations(timeout: 1.0, handler: nil)
        if case .loaded(let data) = state {
            XCTAssertEqual(data.count, 1)
        }else{
            XCTAssertTrue(false,"Weather should initial as empty state")
        }
       
    }

}
class WeatherConfigMock: WeatherConfigType {
    var unit: String {
        "metric"
    }
}
