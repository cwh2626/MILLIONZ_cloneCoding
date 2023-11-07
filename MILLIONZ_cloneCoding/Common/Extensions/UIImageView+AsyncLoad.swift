//
//  UIImageView+AsyncLoad.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/06.
//

import UIKit

extension UIImageView {
    func load(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("URL 문자열이 잘못되었습니다.")
            return
        }

        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = image
                    }
                }
            } catch {
                print("URL에서 이미지를 로드할 수 없습니다: \(url) 에러: \(error)")
            }
        }
    }


}
