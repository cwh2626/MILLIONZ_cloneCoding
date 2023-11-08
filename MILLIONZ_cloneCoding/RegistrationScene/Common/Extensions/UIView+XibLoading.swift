//
//  UIView+XibLoading.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/05.
//

import UIKit

extension UIView {
    func initializeViewFromXib() {
        guard let customView = instantiateFromXib() else { return }
        customView.frame = self.bounds
        self.addSubview(customView)
    }
    
    func instantiateFromXib() -> UIView? {
        let identifier = String(describing: type(of: self))
        guard let customView = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)?.first as? UIView else { return nil }

        return customView
    }
}
