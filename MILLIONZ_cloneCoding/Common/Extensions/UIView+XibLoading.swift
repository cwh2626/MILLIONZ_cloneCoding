//
//  UIView+XibLoading.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/05.
//

import UIKit

extension UIView {
    func loadViewFromXib() {
        let identifier = String(describing: type(of: self))
        guard let customView = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)?.first as? UIView else { return }
        customView.frame = self.bounds

        self.addSubview(customView)
    }
}
