//
//  ViewController.swift
//  TechTest
//
//  Created by Udaldo Jesús Morales Reyes on 30/8/24.
//

import UIKit
import PromiseKit

class PokedexController: UIViewController {
    
    //MARK: Variables
    private var allFirstGenerationPokemons: [Pokemon] = []
    private var firstGenerationPokemons: [Pokemon]?
    private var selectedPokemon:Pokemon?

    private let alertController = UIAlertController(title: "Cargando...", message: nil, preferredStyle: .alert)
    
    //MARK: Outlets
    @IBOutlet weak var pokemonsCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar! //Delegate on Storyboard
    @IBOutlet weak var searchResultsView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getFirstGenerationPokemons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.changeSearchBarApperience()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pokemonsCollectionView.collectionViewLayout.invalidateLayout()
    }

    //MARK: Functions
    func getFirstGenerationPokemons() {
        present(self.alertController, animated: true, completion: nil)
        API.shared.fetchGetPokemonsByGeneration()
            .done { pokemons in
                self.alertController.dismiss(animated: true, completion: nil)
                self.firstGenerationPokemons = pokemons
                self.allFirstGenerationPokemons = pokemons
                self.pokemonsCollectionView.reloadData()
            }.catch { error in
                print(error)
            }

    }
    
    //Change UISearchBar Apperience
    func changeSearchBarApperience() {
        
        self.searchBar.searchTextField.font = UIFont(name: "MontserratRoman-Regular", size: 13)
        
        let newView = UIView(frame: .zero)
        newView.backgroundColor = UIColor(named: "FFC600")
        
        self.searchBar.searchTextField.addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraintRight = newView.trailingAnchor.constraint(equalTo: self.searchBar.searchTextField.trailingAnchor, constant: -5)
        let constraintTop = newView.topAnchor.constraint(equalTo: self.searchBar.searchTextField.topAnchor, constant: 2)
        let constraintBottom = newView.bottomAnchor.constraint(equalTo: self.searchBar.searchTextField.bottomAnchor, constant: -2)
        let constraintWidth = newView.widthAnchor.constraint(equalToConstant: self.searchBar.searchTextField.frame.height-2)
        NSLayoutConstraint.activate([constraintTop, constraintRight, constraintBottom, constraintWidth])
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        
        newView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        let centerXConstraint = button.centerXAnchor.constraint(equalTo: newView.centerXAnchor)
        let centerYConstraint = button.centerYAnchor.constraint(equalTo: newView.centerYAnchor)
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
        
        newView.layer.cornerRadius = constraintWidth.constant / 2
        
        self.searchBar.searchTextField.layer.cornerRadius = 20
        self.searchBar.searchTextField.layer.masksToBounds = true
        self.searchBar.searchTextField.leftView = nil

    }
    
    //Set Simple Loading Alert
    func setSimpleAlertLoading() {
        
        //let alert = UIAlertAction(title: nil, style: .default)
    }
    
    //MARK: Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let destination = segue.destination as? PokedexDetail {
                destination.pokemon = self.selectedPokemon!
            }
        }
    }
    
    //MARK: Get CGFloat Value
    fileprivate func getCgFloatValue(isPortrait: Bool, valuePhone: CGFloat, valuePortrait: CGFloat, valueLandscape: CGFloat) -> CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? valuePhone : (isPortrait ? valuePortrait : valueLandscape)
    }
    
}

//MARK: Extension: UICollectionView DataSource
extension PokedexController:UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.firstGenerationPokemons?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokemonCell", for: indexPath) as! PokemonCell
        cell.setupCell(pokemon: self.firstGenerationPokemons![indexPath.item], indexPath: indexPath)
        return cell
    }
    
}

//MARK: Extension: UICollectionView Delegate
extension PokedexController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedPokemon = self.firstGenerationPokemons![indexPath.item]
        self.performSegue(withIdentifier: "toDetail", sender: self)
    }
}

//MARK: Extension: UICollectionView Flow Layout Delegate
extension PokedexController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullSize = collectionView.frame.size
        let isPortrait = self.view.frame.width < self.view.frame.height
        let width:CGFloat = self.getCgFloatValue(isPortrait: isPortrait, valuePhone: fullSize.width * 0.46, valuePortrait: fullSize.width * 0.25, valueLandscape: fullSize.width * 0.2)
        let height: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 160 : 150
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let fullSize = collectionView.frame.size
        let isPortrait = self.view.frame.width < self.view.frame.height
        let insetTopBottom:CGFloat = 10
        let insetLeftRight = self.getCgFloatValue(isPortrait: isPortrait, valuePhone: fullSize.width * 0.03, valuePortrait: fullSize.width * 0.05, valueLandscape: fullSize.width * 0.05)
        return UIEdgeInsets(top: insetTopBottom, left: insetLeftRight, bottom: insetTopBottom, right: insetLeftRight)
    }
    
}

//MARK: SearchBar Extension
extension PokedexController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Animate searchResultsView hiding or showing
        let shouldBeHidden = searchText.isEmpty ? true : false
        if (shouldBeHidden != self.searchResultsView.isHidden) {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                self.searchResultsView.isHidden = shouldBeHidden
            }, completion: nil)
        }
        
        //Filtering by id or name
        self.firstGenerationPokemons!.removeAll()
        for pokemon in self.allFirstGenerationPokemons {
            
            /*
            if ( (String(pokemon.id).contains(searchText.lowercased()) ) || ( pokemon.name.lowercased().contains(searchText.lowercased()) )) {
                self.firstGenerationPokemons!.append(pokemon)
            }
             */
            if let numberSearchText = Int(searchText) {
                if (numberSearchText == pokemon.id) {
                    self.firstGenerationPokemons!.append(pokemon)
                }
            } else {
                if (searchText.count > 1), searchText[searchText.startIndex] == "#" {
                    let substring = searchText.suffix(from: searchText.index(after: searchText.startIndex))
                    if let numSubstring = Int(substring) {
                        if (numSubstring == pokemon.id) {
                            self.firstGenerationPokemons!.append(pokemon)
                        }
                    }
                } else {
                    if (pokemon.name.lowercased().contains(searchText.lowercased())) {
                        self.firstGenerationPokemons!.append(pokemon)
                    }
                }
            }
        
        if searchText.isEmpty {
            self.firstGenerationPokemons = self.allFirstGenerationPokemons
        }
        self.pokemonsCollectionView.reloadData()
        
        }
    }

}
