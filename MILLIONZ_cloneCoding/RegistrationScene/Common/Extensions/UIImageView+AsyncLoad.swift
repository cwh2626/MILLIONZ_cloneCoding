//
//  UIImageView+AsyncLoad.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/06.
//

import UIKit

extension UIImageView {
  
    func loadImage(withURL urlString: String) {
        
        // 캐시된 이미지가 있다면 설정하고 반환
        if let cachedImage = ImageCacheManager.shared.image(forKey: urlString) {
            self.image = cachedImage
            return
        }
        
        // 캐시된 이미지가 없다면 다운로드
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let downloadedImage = UIImage(data: data) {
                    if let error = error {
                        print("이미지 다운로드 에러: \(error.localizedDescription)")
                        return
                    }
                    
                    // HTTP 응답 상태 코드를 확인합니다.
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        print("서버로부터 유효하지 않은 응답을 받았습니다.")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        ImageCacheManager.shared.setImage(downloadedImage, forKey: urlString)
                        self.image = downloadedImage
                    }
                }
            }.resume()
        }
    }


}
