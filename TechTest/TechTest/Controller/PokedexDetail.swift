//
//  PokedexDetail.swift
//  TechTest
//
//  Created by Udaldo Jesús Morales Reyes on 2/9/24.
//

import UIKit

class PokedexDetail: UIViewController {
    
    //MARK: Segue Variables
    var pokemon:Pokemon?
    
    //MARK: Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageBackColor: UIView!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: Stats Outlets
    @IBOutlet weak var hpNumber: UILabel!
    @IBOutlet weak var hpProgressBar: UIProgressView!
    @IBOutlet weak var attackNumber: UILabel!
    @IBOutlet weak var attackProgressBar: UIProgressView!
    @IBOutlet weak var defenseNumber: UILabel!
    @IBOutlet weak var defenseProgressBar: UIProgressView!
    @IBOutlet weak var specialAttackNumber: UILabel!
    @IBOutlet weak var specialAttackProgressBar: UIProgressView!
    @IBOutlet weak var specialDefenseNumber: UILabel!
    @IBOutlet weak var specialDefenseProgressBar: UIProgressView!
    @IBOutlet weak var speedNumber: UILabel!
    @IBOutlet weak var speedProgressBar: UIProgressView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let pokemon = self.pokemon {
            self.imageBackColor.layer.cornerRadius = 15
            self.preparePokemonDetail(pokemon:pokemon)
        } else {
            self.imageBackColor.backgroundColor = .none
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Functions
    //MARK: PreparePokemonDetail
    func preparePokemonDetail(pokemon:Pokemon) {
        
        self.navigationItem.title = pokemon.name.capitalized
        
        self.descriptionTextView.text = "\(pokemon.name.capitalized)..."

        if let color = pokemon.specie?.color.name {
            if let uiColor = UIColor.getUIColorByPokemonString(color) {
                self.imageBackColor.backgroundColor = uiColor
                for progressBar in [self.hpProgressBar, self.attackProgressBar, self.defenseProgressBar, self.specialAttackProgressBar, self.specialDefenseProgressBar, self.speedProgressBar] {
                    progressBar?.progressTintColor = uiColor
                }
            }
        }
        
        let pokemonStats = pokemon.stats
        
        if let url = pokemon.imageUrl {
            API.shared.downloadImageByURL(url: url)
            .done { uiImage in
                self.image.image = uiImage
            }.catch { error in
                print(error)
            }
        }
        
        print(pokemon.weight)
        print(pokemon.height)
        
        self.weight.text = "\(pokemon.weight/10) kg"
        self.height.text = "\(pokemon.height/10) m"
        
        for stat in pokemonStats {
            switch stat.stat.name {
            case .hp:
                self.hpNumber.text = "\(stat.base_stat)"
                self.hpProgressBar.progress = (Float((stat.base_stat*100)/255)/100)
            case .attack:
                self.attackNumber.text = "\(stat.base_stat)"
                self.attackProgressBar.progress = (Float((stat.base_stat*100)/190)/100)
            case .defense:
                self.defenseNumber.text = "\(stat.base_stat)"
                self.defenseProgressBar.progress = (Float((stat.base_stat*100)/230)/100)
            case .specialAttack:
                self.specialAttackNumber.text = "\(stat.base_stat)"
                self.specialAttackProgressBar.progress = (Float((stat.base_stat*100)/194)/100)
            case .specialDefense:
                self.specialDefenseNumber.text = "\(stat.base_stat)"
                self.specialDefenseProgressBar.progress = (Float((stat.base_stat*100)/230)/100)
            case .speed:
                self.speedNumber.text = "\(stat.base_stat)"
                self.speedProgressBar.progress = (Float((stat.base_stat*100)/180)/100)
            case .other:
                print("Other")
            }
        }
        
    }

}
