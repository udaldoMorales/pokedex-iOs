//
//  UIColorByString.swift
//  TechTest
//
//  Created by Udaldo Jesús Morales Reyes on 3/9/24.
//

import Foundation
import UIKit

extension UIColor {
    
    class func getUIColorByPokemonString(_ str: String) -> UIColor? {
        switch str {
        case "red":
            return UIColor.red
        case "blue":
            return UIColor.blue
        case "brown":
            return UIColor.brown
        case "gray":
            return UIColor.gray
        case "green":
            return UIColor.green
        case "pink":
            return UIColor.systemPink
        case "purple":
            return UIColor.purple
        case "black":
            return UIColor.black
        case "white":
            return UIColor.white
        case "yellow":
            return UIColor.yellow
        default:
            return nil
        }
    }
    
}
