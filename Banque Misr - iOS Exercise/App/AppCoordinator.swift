//
//  AppCoordinator.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 06/10/2024.
//
import UIKit
class AppCoordinator {

    func showAlert(from viewController: UIViewController, message: MessageType) {
          let alert = UIAlertController(title: message.title, message: message.description, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          viewController.present(alert, animated: true, completion: nil)
      }
}
