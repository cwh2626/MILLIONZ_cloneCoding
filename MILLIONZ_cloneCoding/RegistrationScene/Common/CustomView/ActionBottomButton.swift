//
//  ActionBottomButton.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/05.
//

import UIKit

class ActionBottomButton: UIView {
    // MARK: - Properties
    @IBInspectable var buttonTitle: String? {
        set {
            actionButton.setTitle(newValue, for: .normal)
        }
        get {
            return actionButton.currentTitle
        }
    }
    
    // MARK: - UI Components
    @IBOutlet weak var actionButton: ActionButton!
        
    // MARK: - Initialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initializeViewFromXib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProperties()
    }
    
    // MARK: - Private Methods
    private func setupProperties() {
        actionButton.layer.cornerRadius = 16
        actionButton.backgroundColor = .primary900
    }
}
