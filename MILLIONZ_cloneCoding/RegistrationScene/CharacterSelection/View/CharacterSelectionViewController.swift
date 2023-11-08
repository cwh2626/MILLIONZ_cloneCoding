//
//  CharacterSelectionViewController.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/06.
//

import UIKit
import RxSwift

class CharacterSelectionViewController: UIViewController {
    var viewModel: SharedRegistrationViewModel!
    let disposeBag = DisposeBag()
    var charactersData: [Character] = []
    
    @IBOutlet weak var completeSelectionButtonContainer: ActionBottomButton!
    
    @IBOutlet weak var characterHorizontalCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        registerCell()

        characterHorizontalCollectionView.decelerationRate = .fast
        bindViewModel()
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.showMemberInfo {
            if let destinationVC = segue.destination as? RegistrationCompleteViewController,
               let registrationData = sender as? RegistrationResponse {
                destinationVC.registrationData = registrationData
            }
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
        viewModel.charactersObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] characters in
                guard let self = self else { return }
                self.charactersData = characters.sorted { $0.characterSeq < $1.characterSeq }

                if self.charactersData.count > 0 {
                    self.characterHorizontalCollectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        completeSelectionButtonContainer.actionButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let centerPoint = CGPoint(
                    x: self.characterHorizontalCollectionView.bounds.size.width / 2 + self.characterHorizontalCollectionView.contentOffset.x,
                    y: self.characterHorizontalCollectionView.bounds.size.height / 2
                )
                
                guard let centerIndexPath = self.characterHorizontalCollectionView.indexPathForItem(at: centerPoint) else { return }
                
                let selectedCharacter = charactersData[centerIndexPath.row].characterSeq

                self.viewModel.selectedCharacter(selectedCharacter)
                
                self.viewModel.performRegistration()
                
            })
            .disposed(by: disposeBag)

        viewModel.registrationResultObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] registrationData in
                self?.performSegue(withIdentifier: SegueIdentifier.showMemberInfo, sender: registrationData)
            }, onError: { error in

            })
            .disposed(by: disposeBag)
        
        viewModel.registrationErrorObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showAlert(message: error.message)
            })
            .disposed(by: disposeBag)
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
