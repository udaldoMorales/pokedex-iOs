//
//  Pokemon.swift
//  TechTest
//
//  Created by Udaldo Jesús Morales Reyes on 31/8/24.
//

import Foundation

struct Pokemon: Codable {
    let id: Int
    let name: String
    let imageUrl: String?
    let weight: Float
    let height: Float
    let stats: [PokemonStat]
    var specie: PokemonSpecies?
}

struct PokemonStat: Codable {
    let base_stat: Int
    let effort: Int
    let stat: PokemonStatDetail
}

struct PokemonStatDetail: Codable {
    let name: PokemonStatDetailName
    let url: String
}

enum PokemonStatDetailName: String, Codable {
    case hp = "hp"
    case attack = "attack"
    case defense = "defense"
    case specialAttack = "special-attack"
    case specialDefense = "special-defense"
    case speed = "speed"
    case other
}
