//
//  TextInputBar.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/05.
//

import UIKit
import SnapKit

class TextInputBar: UIView {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var underlineView: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadViewFromXib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProperties()
    }
    
    private func setupProperties() {
        inputTextField.delegate = self

        inputTextField.setClearButton(with: UIImage(named: "btn_x")!, mode: .always)
        inputTextField.updateRightViewVisibility()

        guard let placeholderText = inputTextField.placeholder else { return }
        
        inputTextField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [.font: UIFont(name: "SpoqaHanSansNeo-Regular",
                                       size: 16)!,
                         .foregroundColor: UIColor.black700])
    }
}

extension TextInputBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        underlineView.backgroundColor = .primary900
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        underlineView.backgroundColor = .black400
    }
}

