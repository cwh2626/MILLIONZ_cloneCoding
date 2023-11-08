//
//  UIViewController+Alert.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/08.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
