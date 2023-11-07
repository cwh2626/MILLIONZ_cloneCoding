//
//  CharacterSelectionViewModel.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/06.
//

import RxSwift

class CharacterViewModel {
    let characters: BehaviorSubject<[Character]> = BehaviorSubject(value: [])
    private let characterService: CharacterService
    private let disposeBag = DisposeBag()
    
    init(characterService: CharacterService) {
        self.characterService = characterService
    }
    
    func fetchCharacters() {
        characterService.fetchCharacters()
            .subscribe(onNext: { [weak self] characters in
                self?.characters.onNext(characters)
            }, onError: { error in
                // 에러 처리
            })
            .disposed(by: disposeBag)
    }
}
