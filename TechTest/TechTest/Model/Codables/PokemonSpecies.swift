//
//  PokemonSpecies.swift
//  TechTest
//
//  Created by Udaldo Jesús Morales Reyes on 1/9/24.
//

import Foundation

struct PokemonSpecies: Codable {
    let name: String
    let varieties: [PokemonSpeciesVarieties]
    let color: PokemonSpeciesColor
}

struct PokemonSpeciesVarieties: Codable {
    let is_default: Bool
    let pokemon: PokemonSpeciesPokemon
}

struct PokemonSpeciesPokemon: Codable {
    let name: String
    let url: String
}

struct PokemonSpeciesColor: Codable {
    let name: String
    let url: String
}
