//
//  ActionButton.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/08.
//

import UIKit

class ActionButton: UIButton {    
    override public var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.backgroundColor = .primary900
            } else {
                self.backgroundColor = .black500
            }
        }
    }
}
