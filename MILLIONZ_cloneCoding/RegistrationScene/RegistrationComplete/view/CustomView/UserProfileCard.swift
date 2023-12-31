//
//  UserProfileCard.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/07.
//

import UIKit

class UserProfileCard: UIView {
    // MARK: - UI Components
    @IBOutlet var containerView: UIView!    
    @IBOutlet weak var snsLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var characterNameLabel: UILabel!
    
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
        containerView.layer.cornerRadius = 8        
    }
    
    // MARK: - Public Methods
    func prepare(data: RegistrationResponse) {
        self.snsLabel.text = data.snsType
        self.nicknameLabel.text = data.nickname
        self.characterNameLabel.text = data.characterName
    }
    
    
}
