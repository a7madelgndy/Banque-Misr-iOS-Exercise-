//___FILEHEADER___

/*import XCTest
@testable import Banque_Misr___iOS_Exercise

final class TestingMoviesViewModel: XCTestCase {
    var viewModel: MoviesViewModel!
      var mockNetworkManager: MockNetworkManager!
    override func setUpWithError() throws {
        mockNetworkManager = MockNetworkManager()
               viewModel = MoviesViewModel(networkManager: mockNetworkManager)
    }

    override func tearDownWithError() throws {
        viewModel = nil
              mockNetworkManager = nil
              super.tearDown()
    }
    func testFetchNowPlayingMoviesSuccess() {
          let expectation = XCTestExpectation(description: "Fetch now playing movies successfully")
        mockNetworkManager.mockMovies = [
            Movie(id: 1, title: "movei 1", posterPath: nil),
            Movie(id: 2, title: "movie 2", posterPath: nil)
          ]

          viewModel.nowPlayingDidUpdate = { movies in
              XCTAssertEqual(movies?.count, 2)
              XCTAssertEqual(movies?[0].title, "movei 1")
              expectation.fulfill()
          }

          viewModel.fetchMoviesData()
          wait(for: [expectation], timeout: 1.0)
      }

      func testFetchUpcomingMoviesSuccess() {
          let expectation = XCTestExpectation(description: "Fetch upcoming movies successfully")
          
          mockNetworkManager.mockMovies = [
            Movie(id: 3, title: "movei 1", posterPath: nil),
              Movie(id: 4, title: "movie 2",posterPath: nil)
          ]

          viewModel.upcomingMoviesDidUpdate = { movies in
              XCTAssertEqual(movies?.count, 2)
              XCTAssertEqual(movies?[0].title, "movei 1")
              expectation.fulfill()
          }

          viewModel.fetchMoviesData()
          wait(for: [expectation], timeout: 1.0)
      }

      func testFetchPopularMoviesSuccess() {
          let expectation = XCTestExpectation(description: "Fetch popular movies successfully")
          
          mockNetworkManager.mockMovies = [
            Movie(id: 5, title: "movei 1", posterPath: nil),
              Movie(id: 6, title: "movie 2",posterPath: nil)
          ]

          viewModel.popularMoviesDidUpdate = { movies in
              XCTAssertEqual(movies?.count, 2)
              XCTAssertEqual(movies?[0].title, "movei 1")
              expectation.fulfill()
          }

          viewModel.fetchMoviesData()
          wait(for: [expectation], timeout: 1.0)
      }

      func testFetchMoviesErrorHandling() {
          mockNetworkManager.shouldReturnError = true
          let expectation = XCTestExpectation(description: "Handle error when fetching movies")
          viewModel.nowPlayingDidUpdate = { movies in
              XCTAssertNil(movies)
              expectation.fulfill()
          }

          viewModel.fetchMoviesData()
          wait(for: [expectation], timeout: 1.0)
      }
  }


*
