//
//  ImageLoadingProtocol.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 06/10/2024.
//

import Foundation
import UIKit
protocol ImageLoadingProtocol {
    func fetchImage(with movie: MovieDetail, completion: @escaping (UIImage?) -> Void)
}
