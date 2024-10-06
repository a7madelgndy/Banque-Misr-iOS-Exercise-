//
//  MessageType.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 06/10/2024.
//

import Foundation
enum MessageType {
    case error(String)
    case success(String)
    case warning(String)
    
var title: String {
        switch self {
        case .error:
            return "Error"
        case .success:
            return "Success"
        case .warning:
            return "Warning"
        }
    }
var description: String {
       switch self {
       case .error(let message):
           return message
       case .success(let message):
           return message
       case .warning(let message):
           return message
       }
   }
   
}
