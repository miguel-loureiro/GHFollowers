//
//  Follower.swift
//  GHFollowers
//
//  Created by António Loureiro on 04/03/2024.
//

import Foundation

struct Follower: Codable, Hashable {

    //Como os parametros (login e avatarUrl são String, e esse tipo (String) é Hashable por defeito)
    //por isso não é necessário nenhuma função de hash aqui
    var login: String
    var avatarUrl: String
}
