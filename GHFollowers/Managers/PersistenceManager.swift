//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by António Loureiro on 05/04/2024.
//

import Foundation

enum PersistenceActionType {

    case add
    case remove
}

enum PersistenceManager {

    // vai ter 3 func básicas: retrieve, save e update

    static private let defaults = UserDefaults.standard

    enum Keys {

        static let favorites = "favorites"
    }

    static func retrieveFavorites(completed: @escaping(Result<[Follower], GHFError>) -> Void) {

        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            // aqui vai ver verificar se temos objecto no user defaults
            // se tivermos então favoritesData vai ser decoded abaixo, senão entra no else
            // e coloca-se um array vazio pois na primeira vez não há favoritos
            completed(.success([]))
            return
        }

        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavoriteUser))
        }
    }

    static func saveFavorites(favorites: [Follower]) -> GHFError? {

        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil //retorna-se nil porque não se retorna erro
        } catch  {

            return .unableToFavoriteUser
        }
    }

    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping(GHFError?) -> Void) {

        retrieveFavorites { result in

            switch result {

                case .success(let favorites):
                    var retrievedFavorites = favorites

                    switch actionType {

                    case .add:
                        guard !retrievedFavorites.contains(favorite) else {

                            completed(.alreadyInFavorites)
                            return
                        }
                        retrievedFavorites.append(favorite)

                    case .remove:
                        retrievedFavorites.removeAll {  $0.login == favorite.login }
                    }

                    completed(saveFavorites(favorites: favorites))

                case .failure(let error):
                    completed(error)
            }
        }
    }
}
