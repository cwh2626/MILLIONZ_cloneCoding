//
//  UITextField+ClearButton.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/05.
//

import UIKit

extension UITextField {
    func setClearButton(with image: UIImage, mode: UITextField.ViewMode) {
        var configuration = UIButton.Configuration.plain() // UIButton.Configuration ios 15.0 이상
        configuration.image = image
        configuration.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let clearButton = UIButton(configuration: configuration)
        clearButton.addTarget(self, action: #selector(self.clear), for: .touchUpInside)
        
        self.addTarget(self, action: #selector(self.updateRightViewVisibility), for: .editingChanged)
        
        self.rightView = clearButton
        self.rightViewMode = mode
    }
    
    @objc func updateRightViewVisibility() {
        self.rightView?.isHidden = self.text?.isEmpty ?? true
    }
    
    @objc func clear(sender: AnyObject) {
        self.text = ""
        sendActions(for: .editingChanged)
    }
}
