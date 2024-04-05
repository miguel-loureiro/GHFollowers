//
//  GHFError.swift
//  GHFollowers
//
//  Created by António Loureiro on 28/03/2024.
//

import Foundation

enum GHFError: String, Error {

    case invalidUsername = "This username created an invalid request"
    case unableToComplete = "Unable to complete your request. Check your internet connection"
    case invalidResponse = "Invalid response from the server. Try again"
    case invalidData = "The data received from server was invalid"
    case unableToFavoriteUser = "There was an error trying to favorite this user"
    case alreadyInFavorites = "This user is already a favorite"
}
