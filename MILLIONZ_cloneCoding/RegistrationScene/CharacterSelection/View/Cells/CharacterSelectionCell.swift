//
//  CharacterSelectionCell.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/06.
//

import UIKit

class CharacterSelectionCell: UICollectionViewCell {
    // MARK: - Properties
    static let id = String(describing: CharacterSelectionCell.self)
    
    // MARK: - UI Components
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var innerContentView: UIView!
    @IBOutlet weak var innerShadowView: UIView!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProperties()
    }
    
    // MARK: - Private Methods
    private func setupProperties() {
        innerShadowView.layer.shadowColor = UIColor.black.cgColor
        innerShadowView.layer.shadowOpacity = 0.1
        innerShadowView.layer.shadowOffset = CGSize(width: 0, height: 10)
        innerShadowView.layer.shadowRadius = 16
        innerShadowView.layer.cornerRadius = 16
        innerShadowView.layer.masksToBounds = false
        
        innerContentView.layer.cornerRadius = 16
        innerContentView.layer.borderWidth = 2
        innerContentView.layer.borderColor = UIColor.primary900.cgColor
    }
    
    // MARK: - Public Methods
    func prepare(data: Character) {
        setCellHighlightStatus(isHighlighted: false)
        self.characterImage.loadImage(withURL: data.filePath)
        self.characterName.text = data.korName
        self.characterImage.backgroundColor = CharacterColor(rawValue: data.characterSeq)?.color ?? UIColor.clear
    }
    
    func setCellHighlightStatus(isHighlighted: Bool) {
        self.transform = isHighlighted ? .identity : CGAffineTransform(scaleX: 0.74, y: 0.78)
        self.innerContentView.layer.borderWidth = isHighlighted ? 2 : 0
    }
}
