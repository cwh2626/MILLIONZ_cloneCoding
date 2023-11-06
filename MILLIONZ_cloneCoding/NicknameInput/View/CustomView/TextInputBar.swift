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
    @IBInspectable var characterLimit: Int = 12  {
        didSet {
            characterLimit = max(1, characterLimit)
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
        inputTextField.delegate = self

        inputTextField.setClearButton(with: UIImage(named: "btn_x")!, mode: .always)
        inputTextField.updateRightViewVisibility()
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        guard let placeholderText = inputTextField.placeholder else { return }
        
        inputTextField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [.font: UIFont(name: "SpoqaHanSansNeo-Regular",
                                       size: 16)!,
                         .foregroundColor: UIColor.black700])
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let currentText = textField.text else { return }
        
        let length = currentText.count
        
        if length > characterLimit {
            // 텍스트를 제한 길이만큼 잘라냅니다.
            textField.text = String(currentText.prefix(characterLimit))
        }
    }
}

extension TextInputBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        underlineView.backgroundColor = .primary900
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        underlineView.backgroundColor = .black400
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {return false}
//        print(currentText,currentText.count)
        
        // replacingCharacters 로는 한글의 자음과 모음이 기대값이 나오지않기에 현재 한글의 제한 방법을
        // textViewDidChange함수에서 제한길이를 초과할경우 길이를 넘어간 만큼 자르기로 했다
        // 그런데 버그현상 발견 제한길에 다다랐을떄 마지막 텍스트는 수정이 되지만 백스페이스로 삭제시에
        // 수정전의 텍스트가 text에 스택에 쌓여있던것처럼 나타나서 삭제되는 현상을 발견
        // 그래서 해당 안건의 정확한 원인은 발견못했지만 현재위치의 함수에서 발생할것으로 추측
        // 해결하기위해 현재 위치의 함수에서
        // 입력된 값이 백스페이스이면서, 최대길이의 글이며, 입력바가 마지막일경우
        // 수동으로 text의 마지막값을 제거 하며 return값으 false로 입력된 백스페이스 기능을 못하게 막음으로써 현재 문제 해결
        // text.count == 0 :가 0 인경우는 즉 공백 백스페이스 경우 이다 코드내에서 직접적으로 text = "" 으로 하지않는 이상 현재까지는 백스페이스 이외의 경우를 발견하지 못했다
        // range.location + 1 >= characterLimit : 플러스 1을 한 이유는 입력되고 난뒤의 위치를 표시하기에 제한길에 맞추기 위한값 (백스페이스 위치 맨뒤)
        if string.count == 0 && currentText.count >= characterLimit && range.location + 1 >= characterLimit {
            textField.text?.removeLast()
            
            return false
        }
        return true
    }
}

