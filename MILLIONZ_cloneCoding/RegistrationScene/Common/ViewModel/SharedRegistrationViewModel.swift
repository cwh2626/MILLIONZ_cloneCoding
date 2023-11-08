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
    
    var showErrorAlert: ((String) -> Void)?

    // MARK: - Input
    // 사용자의 입력을 BehaviorSubject로 관리합니다.
//    let snsType = BehaviorSubject<String?>(value: nil)
//    let nickname = BehaviorRelay<String?>(value: nil)
//    let character = BehaviorSubject<String?>(value: nil)
//    let characterName = BehaviorSubject<String?>(value: nil)
    // MARK: - Inputs
    let registerButtonTapped = PublishSubject<Void>()
    
    // MARK: - Outputs
    let registrationResult = PublishSubject<RegistrationResponse>()
    
//    var registrationResponse: PublishSubject<RegistrationResponse> = PublishSubject()
//    var registrationRequest: PublishSubject<RegistrationRequest> = PublishSubject()

    // MARK: - SNS로그인
    // 선택된 SNS 타입을 저장하는 변수
    private let selectedSNSType = BehaviorSubject<SnsType?>(value: nil)

    // MARK: - 닉네임 입력
    // 입력 데이터 관찰
    private let nicknameValue = BehaviorRelay<String>(value: "")
    // 버튼 활성화 상태를 Driver로 변환
    var isNextButtonEnabled: Driver<Bool>!
    
    // MARK: - 캐릭터 선택
    let characters: BehaviorSubject<[Character]> = BehaviorSubject(value: [])
    let selectedCharacter = PublishSubject<Int64>()

    private let characterService: RegistrationService
    // 이미지 캐시를 위한 매니저
//    private let imageCacheManager =
    
    private let disposeBag = DisposeBag()
    
    // 선택된 SNS 타입을 외부로 노출하는 Observable
    var selectedSNSTypeObservable: Observable<SnsType?> {
        return selectedSNSType.asObservable()
    }
    
    // View로부터 호출될 수 있는 public 메소드
    func updateNickname(_ nickname: String) {
        nicknameValue.accept(nickname)
    }

    // 사용자의 선택을 처리하는 메소드
    func selectSnsType(_ type: SnsType) {
        selectedSNSType.onNext(type)
    }
   
    init(characterService: RegistrationService) {
        self.characterService = characterService
        
        setupBindings()
        fetchCharacters()
    }
    
    private func setupBindings() {
        
        isNextButtonEnabled = nicknameValue
            .asObservable()
            .map { [weak self] in self!.isValidNickname($0) }
            .asDriver(onErrorJustReturn: false)
        
        registerButtonTapped
            .withLatestFrom(Observable.combineLatest(selectedSNSType, nicknameValue, selectedCharacter, resultSelector: { snsType, nickname, character in
                return (snsType, nickname, character)
            }))
            .compactMap { snsType, nickname, character -> RegistrationRequest? in
                guard let snsType = snsType else { return nil }
                return RegistrationRequest(snsType: snsType.stringValue, nickname: nickname, character: character)
            }
            .flatMapLatest { [unowned self] request -> Observable<RegistrationResponse> in
                return characterService.register(with: request)
            }
            .subscribe(onNext: { [weak self] response in
                self?.registrationResult.onNext(response)
                
                // SNS로그인화면 말풍선 유무 설정용
                if let snsTypeValue = SnsType(krValue: response.snsType) {
                    UserDefaults.standard.set(snsTypeValue.rawValue, forKey: UserDefaultsKeys.registeredSNSType)
                }

            }, onError: { error in
                print("Registration error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    // 입력한 닉네임이 조건에 맞는지 검증
    private func isValidNickname(_ nickname: String) -> Bool {
        let regex = "^[가-힣A-Za-z0-9]{2,12}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: nickname)
    }
    
    func fetchCharacters() {
        characterService.fetchCharacters()
            .subscribe(onNext: { [weak self] characters in
                self?.characters.onNext(characters)
                // 각 캐릭터의 이미지 URL에 대해 캐싱을 시도합니다.
                characters.forEach { character in
                    self?.cacheCharacterImage(character.filePath)
                }
            }, onError: { error in
                // 에러 처리
            })
            .disposed(by: disposeBag)
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
    
    
    
    // MARK: - Validation
    // 입력된 데이터의 유효성을 검증합니다.
//    var isNicknameValid: Observable<Bool> {
//        return nickname
//            .map { $0?.count ?? 0 >= 2 && $0?.count ?? 0 <= 12 } // 2~12자 조건 검증
//            .share(replay: 1, scope: .whileConnected)
//    }
    
    

    // MARK: - Registration
    // 모든 데이터가 유효할 때 서버에 전송할 수 있는지 여부를 Observable로 제공합니다.
//    var canRegister: Observable<Bool> {
//        return Observable.combineLatest(
//            snsType,
//            nickname,
//            character,
//            characterName
//        ) { snsType, nickname, character, characterName in
//            // 모든 데이터가 nil이 아니고, 닉네임이 유효해야 합니다.
//            return snsType != nil && nickname != nil && character != nil && characterName != nil
//        }
//    }
    
    // MARK: - Registration Command
    // 회원가입을 수행하는 메서드
//    func register() -> Observable<Bool> {
//        // 이 메서드에서는 서버에 데이터를 전송하는 로직을 구현합니다.
//        // 여기에서는 단순히 Observable을 리턴하는 예시를 보여줍니다.
//        
//        // combineLatest를 사용하여 최신 데이터를 가져옵니다.
//        return Observable.combineLatest(snsType, nickname, character, characterName)
//            .take(1) // 단 한 번만 서버에 전송합니다.
//            .flatMapLatest { snsType, nickname, character, characterName in
//                // 서버에 회원가입 요청을 보내고 결과를 Observable로 변환합니다.
//                // 예: networkService.register(...)
//                return .just(true) // 성공했다고 가정합니다.
//            }
//    }
}

