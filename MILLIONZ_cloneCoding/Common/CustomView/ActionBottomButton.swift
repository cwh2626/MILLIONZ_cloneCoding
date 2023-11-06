//
//  ActionBottomButton.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/05.
//

import UIKit

class ActionBottomButton: UIView {
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBInspectable var buttonTitle: String? {
        set {
            actionButton.setTitle(newValue, for: .normal)
        }
        get {
            return actionButton.currentTitle
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initializeViewFromXib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProperties()
    }
    
    private func setupProperties() {
        actionButton.layer.cornerRadius = 16
    }
}
