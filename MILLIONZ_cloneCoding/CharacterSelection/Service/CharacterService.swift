//
//  CharacterService.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/06.
//

import RxSwift
import Foundation

class CharacterService {
    private let apiUrl = Environment.apiUrl
    private let apiToken = Environment.apiToken
    
    func fetchCharacters() -> Observable<[Character]> {
        // 실제 API 호출로 교체하세요
        return Observable.create { observer in
            let url = URL(string: self.apiUrl + "/character")!
            var request = URLRequest(url: url)

            request.httpMethod = "GET"
            request.setValue("Bearer \(self.apiToken)", forHTTPHeaderField: "Authorization")


            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }

                do {
                    let characterResponse = try JSONDecoder().decode(CharacterResponse.self, from: data!)
                    let characters = characterResponse.data

                    observer.onNext(characters)
                } catch {
                    observer.onError(error)
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
