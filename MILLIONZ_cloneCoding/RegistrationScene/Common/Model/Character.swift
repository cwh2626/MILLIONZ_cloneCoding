//
//  Character.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/06.
//

import UIKit



struct Character: Codable {
    let characterSeq: Int64
    let engName: String
    let korName: String
    let filePath: String
}

enum CharacterColor: Int64 {
    case nono = 1
    case gogo
    case dodo

    var color: UIColor {
        switch self {
        case .nono:
            return UIColor.nonoBackground
        case .gogo:
            return UIColor.gogoBackground
        case .dodo:
            return UIColor.dodoBackground
        }
    }
}

