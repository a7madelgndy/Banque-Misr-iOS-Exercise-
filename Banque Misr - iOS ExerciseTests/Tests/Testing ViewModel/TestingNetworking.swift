//
//  TestingNetworking.swift
//  Banque Misr - iOS ExerciseTests
//
//  Created by Ahmed El Gndy on 06/10/2024.
//

import XCTest
@testable import Banque_Misr___iOS_Exercise

final class TestingNetworking: XCTestCase {
    var viewModel: MovieDetailsViewModel!
    var mockNetworkManager: MockNetworkManager!
    var networkManager : NetworkManager?
    
    override func setUpWithError() throws {
        networkManager = NetworkManager()
        mockNetworkManager = MockNetworkManager()
        viewModel = MovieDetailsViewModel(networkingManager: mockNetworkManager)
        
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockNetworkManager = nil }
    func testFetchMovieImageReturnsImage() {
        let mockMovieDetail = MovieDetail(id: 1, title: "Test Movie", overview: "A test movie", runtime: nil, releaseDate: "2023-01-01", posterPath: "/test.jpg", backdropPath: nil, voteAverage: 7.5, voteCount: 100)
        viewModel.movieDetail = mockMovieDetail
        let expectation = self.expectation(description: "Fetch movie image")
        viewModel.fetchMovieImage { image in
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchMovieImageReturnsNilWhenNoMovieDetail() {
        viewModel.movieDetail = nil
        let expectation = self.expectation(description: "Fetch movie image")
        viewModel.fetchMovieImage { image in
            XCTAssertNil(image, "Expected to get nil when movieDetail is nil")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchMoviesReturnsSuccess() {
        let mockMovies = [
            Movie(id: 1, title: "movie title", posterPath: nil),
            Movie(id: 2, title: "movie title2", posterPath: nil)
        ]
        mockNetworkManager.mockMovies = mockMovies
        
        let expectation = self.expectation(description: "Fetch movies")
        mockNetworkManager.fetchMovies(category: .nowPlaying) { result in
            switch result {
            case .success(let movies):
                // Then
                XCTAssertEqual(movies.count, 2)
                XCTAssertEqual(movies.first?.title, "movie title")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected to fetch movies, but got error: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchMoviesReturnsError() {
        mockNetworkManager.shouldReturnError = true
        let expectation = self.expectation(description: "Fetch movies error")
        mockNetworkManager.fetchMovies(category: .nowPlaying) { result in
            switch result {
            case .success:
                XCTFail("Expected to fail fetching movies, but succeeded")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Mock error fetching movies")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchMovieDetailsReturnsSuccess() {
        let mockMovieDetail = MovieDetail(id: 1, title: "Test Movie", overview: "A test movie", runtime: nil, releaseDate: "2023-01-01", posterPath: "/test.jpg", backdropPath: nil, voteAverage: 7.5, voteCount: 100)
        mockNetworkManager.mockMovieDetail = mockMovieDetail
        
        let expectation = self.expectation(description: "Fetch movie details")
        mockNetworkManager.fetchMovieDetails(for: 1) { result in
            switch result {
            case .success(let movieDetail):
                XCTAssertEqual(movieDetail.title, "Test Movie")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected to fetch movie details, but got error: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchMovieDetailsReturnsError() {
        
        let expectation = self.expectation(description: "Fetch movie details error")
         networkManager?.fetchMovieDetails(for: 1024127) { result in
            switch result {
            case .success(let movie):
                XCTAssertNotNil(movie)
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Mock error fetching movie details")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    func testfetchfetchImage() {
        let expectation = self.expectation(description: "Fetch image")
        let mockMovieDetail = MovieDetail(id: 1, title: "Test Movie", overview: "A test movie", runtime: nil, releaseDate: "2023-01-01", posterPath: "/x5AreOAgkTBzUSL58o4jsYortw2.jpg", backdropPath: nil, voteAverage: 7.5, voteCount: 100)
        networkManager?.fetchImage(with: mockMovieDetail , completion: { image in
            XCTAssertNotNil(image)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 20, handler: nil)
    }
    func testFetchMovies() {
        _ = NetworkManager()
        let expectation = self.expectation(description: "Fetch movies")
        self.networkManager?.fetchMovies(category: .nowPlaying) { result in
            switch result {
            case .success(let movies):
                XCTAssertGreaterThan(movies.count, 1, "Expected at least one movie")
            case .failure(let error):
                XCTFail("Expected success, but got error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    
}
