//
//  SharedRegistrationViewModel.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/06.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class SharedRegistrationViewModel {
    // MARK: - Properties
    private let registerButtonTapped = PublishSubject<Void>()
    private let registrationResult = PublishSubject<RegistrationResponse>()

    private let selectedSNSType = BehaviorSubject<SnsType?>(value: nil)
    private let nicknameValue = BehaviorRelay<String>(value: "")
    private let characters = BehaviorSubject<[Character]>(value: [])
    private let selectedCharacter = PublishSubject<Int64>()
    private let registrationError = PublishRelay<ErrorDetail>()
    
    private let registrationService: RegistrationService
    private let disposeBag = DisposeBag()
    
    // MARK: - Observables
    var isNextButtonEnabled: Driver<Bool> {
        nicknameValue
            .asObservable()
            .map { [weak self] in self!.isValidNickname($0) }
            .asDriver(onErrorJustReturn: false)
    }
    
    var registrationErrorObservable: Observable<ErrorDetail> {
        return registrationError.asObservable()
    } 
    
    var registrationResultObservable: Observable<RegistrationResponse> {
        return registrationResult.asObservable()
    }
    
    var charactersObservable: Observable<[Character]> {
        return characters.asObservable()
    }
    
    var selectedSNSTypeObservable: Observable<SnsType?> {
        return selectedSNSType.asObservable()
    }
    
    // MARK: - Initializer
    init(characterService: RegistrationService) {
        self.registrationService = characterService
        
        setupBindings()
        fetchCharacters()
    }
    
    // MARK: - Binding
    private func setupBindings() {
        
        registerButtonTapped
            .withLatestFrom(Observable.combineLatest(selectedSNSType, nicknameValue, selectedCharacter, resultSelector: { snsType, nickname, character in
                return (snsType, nickname, character)
            }))
            .compactMap { snsType, nickname, character -> RegistrationRequest? in
                guard let snsType = snsType else { return nil }
                return RegistrationRequest(snsType: snsType.stringValue, nickname: nickname, character: character)
            }
            .flatMapLatest { [unowned self] request -> Observable<ApiResponse> in
                return registrationService.register(with: request)
            }
            .subscribe(onNext: { [weak self] response in
                if response.result {
                    guard let data = response.data as? RegistrationResponse else { return }
                    self?.registrationResult.onNext(data)
                    
                    // SNS로그인화면 말풍선 유무 설정용
                    if let snsTypeValue = SnsType(krValue: data.snsType) {
                        UserDefaults.standard.set(snsTypeValue.rawValue, forKey: UserDefaultsKeys.registeredSNSType)
                    }
                } else {
                    guard let data = response.error else { return }
                    self?.registrationError.accept(data)
                }
                
                
                
            }, onError: { error in
                print("Registration error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Functions
    func updateNickname(_ nickname: String) {
        nicknameValue.accept(nickname)
    }

    func selectSnsType(_ type: SnsType) {
        selectedSNSType.onNext(type)
    }
    
    func selectedCharacter(_ characterSeq: Int64) {
        selectedCharacter.onNext(characterSeq)
    }
    
    func performRegistration() {
        registerButtonTapped.onNext(())
    }
    
    func fetchCharacters() {
        registrationService.fetchCharacters()
            .subscribe(onNext: { [weak self] characters in
                guard let data = characters.data as? [Character] else { return }
                self?.characters.onNext(data)
                data.forEach { character in
                    self?.cacheCharacterImage(character.filePath)
                }
            }, onError: { error in
                // 에러 처리
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - private Functions
    // 입력한 닉네임이 조건에 맞는지 검증
    private func isValidNickname(_ nickname: String) -> Bool {
        let regex = "^[가-힣A-Za-z0-9]{2,12}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: nickname)
    }
    
    // 이미지 URL을 받아서 캐시하는 함수
    private func cacheCharacterImage(_ imageUrl: String) {
        guard ImageCacheManager.shared.image(forKey: imageUrl) == nil,
        let url = URL(string: imageUrl)
        else { return }
                        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("이미지 다운로드 에러: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("서버로부터 유효하지 않은 응답을 받았습니다.")
                return
            }
            
            if let data = data, let downloadedImage = UIImage(data: data) {
                ImageCacheManager.shared.setImage(downloadedImage, forKey: imageUrl)
            }
        }.resume()
    }
}

