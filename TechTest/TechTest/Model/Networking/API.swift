//
//  API.swift
//  TechTest
//
//  Created by Udaldo Jesús Morales Reyes on 1/9/24.
//

import Foundation
import Alamofire
import PromiseKit
import AlamofireImage

final class API {
    
    //Shared instance for using in different controllers.
    static let shared = API()
    
    /*
    func getPokemonSpeciesByGeneration(
        generationName: String,
        success: @escaping ([PokemonGenerationSpecies]) -> Void,
        failure: @escaping (_ error: Error?) -> ()
    ) {
       
        AF.request("\(URLs.pokemonGeneration)/\(generationName)", method: .get, headers: [.accept("application/json")]).responseData { response in
            
            switch response.result {
            case .success(let dataResponse):
                do {
                    let dataObj = try (JSONSerialization.jsonObject(with: dataResponse)) as? [String:Any]
                    
                    if let obj = dataObj?["pokemon_species"] {
                        let dataData = try JSONSerialization.data(withJSONObject: obj)
                        let pokemonSpecies = try JSONDecoder().decode([PokemonGenerationSpecies].self, from: dataData)
                        //print(pokemonSpecies)
                        success(pokemonSpecies)
                    }
                    
                } catch let error {
                    print("Hay error en \(error)")
                }
            case .failure(let error):
                failure(error)
            }
            
        }
        
    }
     */
    
    //MARK: Get Pokemon Species by Generation
    private func fetchGetPokemonSpeciesByGeneration(generationName: String) -> Promise<[PokemonGenerationSpecies]> {
        
        return Promise { seal in
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                AF.request("\(URLs.pokemonGeneration)/\(generationName)", method: .get, headers: [.accept("application/json")]).responseData { response in
                    
                    switch response.result {
                    case .success(let dataResponse):
                        do {
                            let dataObj = try (JSONSerialization.jsonObject(with: dataResponse)) as? [String:Any]
                            
                            if let obj = dataObj?["pokemon_species"] {
                                let dataData = try JSONSerialization.data(withJSONObject: obj)
                                let pokemonSpecies = try JSONDecoder().decode([PokemonGenerationSpecies].self, from: dataData)
                                //print(pokemonSpecies)
                                seal.fulfill(pokemonSpecies)
                            }
                            
                        } catch let error {
                            print("Hay error en \(error)")
                        }
                    case .failure(let error):
                        seal.reject(error)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    //MARK: Get Pokemon Specie By URL
    /*
    func getPokemonSpeciesByUrl(
        url: String,
        success: @escaping (PokemonSpecies) -> Void,
        failure: @escaping (_ error: Error?) -> ()
    ) {
       
        AF.request(URL(string: url)!, method: .get, headers: [.accept("application/json")]).responseData { response in
            
            switch response.result {
            case .success(let dataResponse):
                do {
                    let dataObj = try (JSONSerialization.jsonObject(with: dataResponse)) as? [String:Any]
                    
                    let name = dataObj?["name"] as! String
                    var varitysArray:[PokemonSpeciesVarieties] = []
                    if let varietiesArray = dataObj?["varieties"] as? [[String:Any]] {
                        
                        for varity in varietiesArray {
                            let is_default = varity["is_default"] as! Bool
                            let pokemon = varity["pokemon"] as! [String:Any]
                            let pokemon_name = pokemon["name"] as! String
                            let pokemon_url = pokemon["url"] as! String
                            let pokemonObj = PokemonSpeciesPokemon(name: pokemon_name, url: pokemon_url)
                            let varityObj = PokemonSpeciesVarieties(is_default: is_default, pokemon: pokemonObj)
                            varitysArray.append(varityObj)
                        }
                        
                    }
                    
                    let pokemonSpecies = PokemonSpecies(name: name, varieties: varitysArray)
                    //print(pokemonSpecies)
                    success(pokemonSpecies)
                    
                } catch let error {
                    print("Hay error en \(error)")
                }
            case .failure(let error):
                failure(error)
            }
            
        }
        
    }
     */
    
    private func fetchGetPokemonSpeciesByUrl(url:String) -> Promise<PokemonSpecies> {
        
        return Promise { seal in
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                AF.request(URL(string: url)!, method: .get, headers: [.accept("application/json")]).responseData { response in
                    
                    switch response.result {
                    case .success(let dataResponse):
                        do {
                            let dataObj = try (JSONSerialization.jsonObject(with: dataResponse)) as? [String:Any]
                            
                            let name = dataObj?["name"] as! String
                            var varitysArray:[PokemonSpeciesVarieties] = []
                            if let varietiesArray = dataObj?["varieties"] as? [[String:Any]] {
                                
                                for varity in varietiesArray {
                                    let is_default = varity["is_default"] as! Bool
                                    let pokemon = varity["pokemon"] as! [String:Any]
                                    let pokemon_name = pokemon["name"] as! String
                                    let pokemon_url = pokemon["url"] as! String
                                    let pokemonObj = PokemonSpeciesPokemon(name: pokemon_name, url: pokemon_url)
                                    let varityObj = PokemonSpeciesVarieties(is_default: is_default, pokemon: pokemonObj)
                                    varitysArray.append(varityObj)
                                }
                                
                            }
                            
                            let pokemonSpecies = PokemonSpecies(name: name, varieties: varitysArray)
                            //print(pokemonSpecies)
                            seal.fulfill(pokemonSpecies)
                            
                        } catch let error {
                            print("Hay error en \(error)")
                        }
                    case .failure(let error):
                        seal.reject(error)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    //MARK: Get Pokemon By URL
    /*
    func getPokemonByUrl(
        url: String,
        success: @escaping (Pokemon) -> Void,
        failure: @escaping (_ error: Error?) -> ()
    ) {
       
        AF.request(URL(string: url)!, method: .get, headers: [.accept("application/json")]).responseData { response in
            
            switch response.result {
            case .success(let dataResponse):
                do {
                    let dataObj = try (JSONSerialization.jsonObject(with: dataResponse)) as? [String:Any]
                    
                    //Getting id
                    let id = dataObj?["id"] as? Int
                    
                    //Getting name
                    let name = dataObj?["name"] as? String
                    
                    //Getting weight
                    let weight = dataObj?["weight"] as? Float
                    
                    //Getting height
                    let height = dataObj?["height"] as? Float
                    
                    //Getting imageUrl
                    let sprites = dataObj?["sprites"] as? [String:Any]
                    let spritesOther = sprites?["other"] as? [String:Any]
                    let spritesOtherHome = spritesOther?["home"] as? [String:Any]
                    let imageUrl = spritesOtherHome?["front_default"] as? String
                    
                    //Getting stats
                    var statsArray:[PokemonStat] = []
                    if let stats = dataObj?["stats"] as? [[String:Any]] {
                        for statElement in stats {
                            let base_stat = statElement["base_stat"] as? Int
                            let effort = statElement["effort"] as? Int
                            if let statDetail = statElement["stat"] as? [String:Any] {
                                let statName = statDetail["name"] as? String
                                let statNameEnumed = PokemonStatDetailName.init(rawValue: statName!) 
                                let statUrl = statDetail["url"] as? String
                                let pokemonStatDetail = PokemonStatDetail(name: statNameEnumed ?? .other, url: statUrl!)
                                statsArray.append(PokemonStat(base_stat: base_stat!, effort: effort!, stat: pokemonStatDetail))
                            }
                        }
                    }
                    
                    let pokemon = Pokemon(id: id!, name: name!, imageUrl: imageUrl!, weight: weight!, height: height!, stats: statsArray)
                    
                    //print(pokemon)
                    success(pokemon)
                    
                } catch let error {
                    print("Hay error en \(error)")
                }
            case .failure(let error):
                failure(error)
            }
            
        }
        
    }
     */
    
    private func fetchGetPokemonByUrl(url:String) -> Promise<Pokemon> {
        
        return Promise { seal in
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                AF.request(URL(string: url)!, method: .get, headers: [.accept("application/json")]).responseData { response in
                    
                    switch response.result {
                    case .success(let dataResponse):
                        do {
                            let dataObj = try (JSONSerialization.jsonObject(with: dataResponse)) as? [String:Any]
                            
                            //Getting id
                            let id = dataObj?["id"] as? Int
                            
                            //Getting name
                            let name = dataObj?["name"] as? String
                            
                            //Getting weight
                            let weight = dataObj?["weight"] as? Float
                            
                            //Getting height
                            let height = dataObj?["height"] as? Float
                            
                            //Getting imageUrl
                            let sprites = dataObj?["sprites"] as? [String:Any]
                            let spritesOther = sprites?["other"] as? [String:Any]
                            let spritesOtherHome = spritesOther?["home"] as? [String:Any]
                            let imageUrl = spritesOtherHome?["front_default"] as? String
                            
                            //Getting stats
                            var statsArray:[PokemonStat] = []
                            if let stats = dataObj?["stats"] as? [[String:Any]] {
                                for statElement in stats {
                                    let base_stat = statElement["base_stat"] as? Int
                                    let effort = statElement["effort"] as? Int
                                    if let statDetail = statElement["stat"] as? [String:Any] {
                                        let statName = statDetail["name"] as? String
                                        let statNameEnumed = PokemonStatDetailName.init(rawValue: statName!)
                                        let statUrl = statDetail["url"] as? String
                                        let pokemonStatDetail = PokemonStatDetail(name: statNameEnumed ?? .other, url: statUrl!)
                                        statsArray.append(PokemonStat(base_stat: base_stat!, effort: effort!, stat: pokemonStatDetail))
                                    }
                                }
                            }
                            
                            let pokemon = Pokemon(id: id!, name: name!, imageUrl: imageUrl, weight: weight!, height: height!, stats: statsArray)
                            
                            //print(pokemon)
                            seal.fulfill(pokemon)
                            
                        } catch let error {
                            print("Hay error en \(error)")
                        }
                    case .failure(let error):
                        seal.reject(error)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    //MARK: Get Pokemons By Generation
    /*
    func getPokemonsByGeneration(
        generationName:String = "generation-i",
        success: @escaping ([Pokemon]) -> Void,
        failure: @escaping (_ error: Error?) -> Void
    ) {
        
        var generationPokemons:[Pokemon] = []
        
        self.getPokemonSpeciesByGeneration(generationName: generationName) { pokemonGenerationSpecies in
            for generationSpecie in pokemonGenerationSpecies {
                self.getPokemonSpeciesByUrl(url: generationSpecie.url) { pokemonSpecie in
                    let pokemonUrls = pokemonSpecie.varieties.filter{ $0.is_default == true }.map{ $0.pokemon.url }
                    for pokemonUrl in pokemonUrls {
                        self.getPokemonByUrl(url: pokemonUrl) { pokemon in
                            generationPokemons.append(pokemon)
                        } failure: { error3 in
                            print("Error in processing")
                            failure(error3)
                        }
                    }
                } failure: { error2 in
                    print("Error in processing")
                    failure(error2)
                }
            }
        } failure: { error1 in
            print("Error in processing")
            failure(error1)
        }

        
    }
     */
    
    //MARK: Fetch Pokemons by Generation
    func fetchGetPokemonsByGeneration(generationName:String = "generation-i") -> Promise<[Pokemon]> {
        
        return Promise { seal in
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                //var pokemonsToSend:[Pokemon] = []
                
                firstly {
                    self.fetchGetPokemonSpeciesByGeneration(generationName: generationName)
                }.thenMap { pokemonGenerationSpecie in
                    self.fetchGetPokemonSpeciesByUrl(url: pokemonGenerationSpecie.url)
                }.done { species in
                    var promiseChain:[Promise<Pokemon>] = []
                    for specie in species {
                        for variant in specie.varieties {
                            promiseChain.append(self.fetchGetPokemonByUrl(url: variant.pokemon.url))
                        }
                    }
                    when(fulfilled: promiseChain).done { pokemons in
                        //pokemonsToSend = pokemons
                        //seal.fulfill(pokemonsToSend)
                        seal.fulfill(pokemons)
                    }
                }.catch { error in
                    print(error)
                    seal.reject(error)
                }
                
            }
        
        }
            
        }
        
        
    //MARK: Download Images
    func downloadImageByURL(url:String) -> Promise<UIImage> {
        
        return Promise { seal in
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                AF.request(url).responseImage { response in
                    switch response.result {
                    case .success(let image):
                        seal.fulfill(image)
                    case .failure(let error):
                        seal.reject(error)
                    }
                }
                
            }
    
        }
    }
    
}
