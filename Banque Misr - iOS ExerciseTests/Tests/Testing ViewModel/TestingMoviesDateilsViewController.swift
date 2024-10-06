//
//  TestingMoviesDateilsViewController.swift
//  Banque Misr - iOS ExerciseTests
//
//  Created by Ahmed El Gndy on 06/10/2024.
//

import XCTest
@testable import Banque_Misr___iOS_Exercise

final class TestingMoviesDateilsViewController: XCTestCase {

    var viewModel: MovieDetailsViewModel!
    var mockImageLoader: MockImageLoader!

    override func setUpWithError() throws {
        mockImageLoader = MockImageLoader()
               viewModel = MovieDetailsViewModel(networkingManager: mockImageLoader)
    }

    override func tearDownWithError() throws {
        viewModel = nil
                mockImageLoader = nil
            
    }
    func testFetchMovieImageReturnsImage() {
        let mockMovieDetail = MovieDetail(
            id: 1024127,
            title: "King of Killers",
            overview: "This is a sample movie overview.",
            runtime: nil,
            releaseDate: "2024-01-01",
            posterPath: "/x5AreOAgkTBzUSL58o4jsYortw2.jpg",
            
            backdropPath: nil,
            voteAverage: 7.5,
            voteCount: 150
        )

        viewModel.movieDetail = mockMovieDetail
        mockImageLoader.shouldReturnImage = true

        // When
        let expectation = self.expectation(description: "Fetch image")
        viewModel.fetchMovieImage { image in
        //id: 1024127, title: "King of Killers", posterPath: Optional("/x5AreOAgkTBzUSL58o4jsYortw2.jpg"//
        
            XCTAssertNotNil(image)
    
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

      func testFetchMovieImageReturnsNilWhenNoMovieDetail() {
          viewModel.movieDetail = nil
          let expectation = self.expectation(description: "Fetch image with no movie detail")
          viewModel.fetchMovieImage { image in
              XCTAssertNil(image, "Expected to get nil when no movie detail is set")
              expectation.fulfill()
          }
          waitForExpectations(timeout: 1, handler: nil)
      }

}
