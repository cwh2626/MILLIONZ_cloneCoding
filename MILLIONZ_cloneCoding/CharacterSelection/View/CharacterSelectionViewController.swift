//
//  CharacterSelectionViewController.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/06.
//

import UIKit
import RxSwift

class CharacterSelectionViewController: UIViewController {
    var viewModel: CharacterViewModel!
    let disposeBag = DisposeBag()
    var charactersData: [Character] = []
    
    
    @IBOutlet weak var characterHorizontalCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = CharacterViewModel(characterService: CharacterService())
        setupDelegate()
        registerCell()

        characterHorizontalCollectionView.decelerationRate = .fast
        bindViewModel()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        print(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        let firstIndexPath = IndexPath(item: 0, section: 0)
        if let firstCell = characterHorizontalCollectionView.cellForItem(at: firstIndexPath) as? CharacterSelectionCell {
            firstCell.transform = .identity
            firstCell.innerContentView.layer.borderWidth = 2
        }
    }
    
    private func setupDelegate () {
        characterHorizontalCollectionView.delegate = self
        self.characterHorizontalCollectionView.dataSource = self
    }
    
    private func registerCell() {
        self.characterHorizontalCollectionView.register(UINib(nibName: CharacterSelectionCell.id, bundle: nil),
                                                        forCellWithReuseIdentifier: CharacterSelectionCell.id)
    }
    
    private func bindViewModel() {
        viewModel.characters
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] characters in
                guard let self = self else { return }
                self.charactersData = characters.sorted { $0.characterSeq < $1.characterSeq }

                if self.charactersData.count > 0 {
                    self.characterHorizontalCollectionView.reloadData()
                }
                
                // 이거 두번 호출되서 계속 모양이 이상해지는듯 그리고 시쿼스값에 맞추어서 배열값 집어넣자
                print("bind 호출",self.charactersData.count)
                // UI를 캐릭터 데이터로 업데이트하세요
                
            })
            .disposed(by: disposeBag)
        
        viewModel.fetchCharacters()
    }
}


extension CharacterSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charactersData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterSelectionCell.id, for: indexPath) as! CharacterSelectionCell
        
        let character = charactersData[indexPath.item]
        
        print(indexPath.item, character.characterSeq)
        
        cell.prepare(data: character)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        let center = CGPoint(x: collectionView.contentOffset.x + collectionView.bounds.size.width / 2, y: collectionView.bounds.size.height / 2)
        
        collectionView.visibleCells.forEach { cellItem in
            let cell = cellItem as! CharacterSelectionCell
            guard let indexPath = collectionView.indexPath(for: cell),
                  let layoutAttributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
            
            UIView.animate(withDuration: 0.2) {
                if layoutAttributes.frame.contains(center) {
                    cell.transform = .identity
                    cell.innerContentView.layer.borderWidth = 2
                } else {
                    cell.transform = CGAffineTransform(scaleX: 0.74, y: 0.78)
                    cell.innerContentView.layer.borderWidth = 0
                }
            }
        }
    }

    
}
