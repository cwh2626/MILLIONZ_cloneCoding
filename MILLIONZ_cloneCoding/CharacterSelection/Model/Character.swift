//
//  Character.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/06.
//

import UIKit

struct CharacterResponse: Codable {
  let result: Bool
  let message: String
  let error: String?
  let data: [Character]
}

struct Character: Codable {
    let characterSeq: Int
    let engName: String
    let korName: String
    let filePath: String
}

enum CharacterColor: Int {
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

