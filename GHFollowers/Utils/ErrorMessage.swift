//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by António Loureiro on 04/03/2024.
//

import Foundation

enum ErrorMessage: String {

    case invalidUsername = "This username created an invalid request"
    case unableToComplete = "Unable to complete your request. Check your internet connection"
    case invalidResponse = "Invalid response from the server. Try again"
    case invalidData = "The data received from server was invalid"
}
