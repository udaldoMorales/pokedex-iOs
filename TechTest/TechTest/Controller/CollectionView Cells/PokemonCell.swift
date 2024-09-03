//
//  PokemonCell.swift
//  TechTest
//
//  Created by Udaldo Jesús Morales Reyes on 1/9/24.
//

import UIKit

class PokemonCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var id: UILabel!
    
    func setupCell(pokemon: Pokemon, indexPath: IndexPath) {
        self.name.text = pokemon.name.capitalized
        self.id.text = "#\(pokemon.id)"
        self.getImage(url: pokemon.imageUrl)
        
        self.layer.cornerRadius = 15
    }
    
    private func getImage(url:String?) {
        self.image.image = nil
        if let url = url {
            API.shared.downloadImageByURL(url: url)
            .done { uiImage in
                self.image.image = uiImage
            }.catch { error in
                print(error)
            }
        }
    }
}
