//
//  MockImageLoader.swift
//  Banque Misr - iOS ExerciseTests
//
//  Created by Ahmed El Gndy on 06/10/2024.
//

import Foundation
import UIKit
@testable import Banque_Misr___iOS_Exercise

class MockImageLoader: ImageLoadingProtocol {
    var shouldReturnImage: Bool = false
    func fetchImage(with movie: MovieDetail, completion: @escaping (UIImage?) -> Void) {
        if shouldReturnImage {
            let image = UIImage(systemName: "1")
            completion(image)
        } else {
            
            completion(nil)
        }
    }
}
