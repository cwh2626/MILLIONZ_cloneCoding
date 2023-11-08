//
//  RegistrationService.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/06.
//

import RxSwift
import Foundation

class RegistrationService {
    private let apiUrl = Environment.apiUrl
    private let apiToken = Environment.apiToken
    
    func fetchCharacters() -> Observable<ApiResponse> {
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
                
                guard let data = data else {
                    observer.onError(RxError.noElements)
                    return
                }

                do {
                    let responseData = try JSONDecoder().decode(ApiResponse.self, from: data)

                    observer.onNext(responseData)
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
    
    func register(with requestData: RegistrationRequest) -> Observable<ApiResponse> {
        return Observable.create { observer in
        
            let url = URL(string: self.apiUrl + "/regist")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(self.apiToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let jsonData = try JSONEncoder().encode(requestData)
                request.httpBody = jsonData
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
            
            // URLSession을 사용하여 요청을 수행합니다.
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    observer.onError(RxError.noElements)
                    return
                }

                do {
                    let responseData = try JSONDecoder().decode(ApiResponse.self, from: data)

                    observer.onNext(responseData)
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
