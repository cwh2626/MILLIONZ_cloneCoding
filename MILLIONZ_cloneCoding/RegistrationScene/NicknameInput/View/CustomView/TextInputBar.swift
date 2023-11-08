//
//  TextInputBar.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/05.
//

import UIKit
import SnapKit

class TextInputBar: UIView {
    // MARK: - Properties
    @IBInspectable var characterLimit: Int = 12  {
        didSet {
            characterLimit = max(1, characterLimit)
        }
    }
    
    // MARK: - UI Components
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var underlineView: UIView!
    
    // MARK: - Initialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initializeViewFromXib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProperties()
    }
    
    // MARK: - Action Methods
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let currentText = textField.text else { return }
        
        if currentText.count > characterLimit {
            textField.text = String(currentText.prefix(characterLimit))
        }
    }
    
    // MARK: - Utility Methods
    private func setupProperties() {
        inputTextField.delegate = self

        inputTextField.setClearButton(with: UIImage(named: ImageNames.clearButtonImage)!, mode: .always)
        inputTextField.updateRightViewVisibility()
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        guard let placeholderText = inputTextField.placeholder else { return }
        
        inputTextField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [.font: UIFont(name: FontNames.spoqaHanSansNeoRegular,
                                       size: 16)!,
                         .foregroundColor: UIColor.black700])
    }    
}

// MARK: - Extensions
extension TextInputBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        underlineView.backgroundColor = .primary900
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        underlineView.backgroundColor = .black400
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool 
    {
        guard let currentText = textField.text else { return false }

        if string.count == 0 &&
            currentText.count >= characterLimit &&
            range.location + 1 >= characterLimit
        {
            textField.text?.removeLast()
            return false
        }
        
        return true
    }
}

