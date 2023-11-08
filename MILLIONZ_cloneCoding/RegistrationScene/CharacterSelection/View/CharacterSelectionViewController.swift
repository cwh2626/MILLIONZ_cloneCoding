//
//  CharacterSelectionViewController.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/06.
//

import UIKit
import RxSwift

class CharacterSelectionViewController: UIViewController {
    // MARK: - Properties
    var viewModel: SharedRegistrationViewModel!
    private let disposeBag = DisposeBag()
    private var charactersData: [Character] = []
    private var isSetupComplete = false
    private var centerPoint: CGPoint {
        return CGPoint(
            x: self.characterHorizontalCollectionView.bounds.size.width / 2 + self.characterHorizontalCollectionView.contentOffset.x,
            y: self.characterHorizontalCollectionView.bounds.size.height / 2
        )
    }
    
    // MARK: - UI Components
    @IBOutlet weak var completeSelectionButtonContainer: ActionBottomButton!
    @IBOutlet weak var characterHorizontalCollectionView: UICollectionView!
    @IBOutlet weak var centeredFlowLayout: CenteredFlowLayout!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        characterHorizontalCollectionView.decelerationRate = .fast
        
        let nib = UINib(nibName: CharacterSelectionCell.id, bundle: nil)
        
        if let nibView = nib.instantiate(withOwner: nil, options: nil).first as? UIView {
            centeredFlowLayout.itemSize = nibView.frame.size
        }
        
        setupDelegate()
        registerCell(nib: nib)
        bindViewModel()
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.charactersObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] characters in
                guard let self = self else { return }
                self.charactersData = characters.sorted { $0.characterSeq < $1.characterSeq }
                isSetupComplete = false
                
                if self.charactersData.count > 0 {
                    self.characterHorizontalCollectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        completeSelectionButtonContainer.actionButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let centerIndexPath = self.characterHorizontalCollectionView.indexPathForItem(at: centerPoint) 
                else { return }
                
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
    
    // MARK: - Private Methods
    private func setupDelegate () {
        self.characterHorizontalCollectionView.delegate = self
        self.characterHorizontalCollectionView.dataSource = self
    }
    
    private func registerCell(nib: UINib) {
        self.characterHorizontalCollectionView.register(nib, forCellWithReuseIdentifier: CharacterSelectionCell.id)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueIdentifier.showMemberInfo:
            if let destinationVC = segue.destination as? RegistrationCompleteViewController ,
               let registrationData = sender as? RegistrationResponse {
                destinationVC.registrationData = registrationData
            }
        default:
            break
        }
    }
}

// MARK: - Extensions
extension CharacterSelectionViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegate
{
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charactersData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterSelectionCell.id, for: indexPath) as! CharacterSelectionCell
        let character = charactersData[indexPath.item]
        
        cell.prepare(data: character)
        
        if !isSetupComplete && indexPath.item == 0{
            cell.setCellHighlightStatus(isHighlighted: true)
            isSetupComplete = true
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        collectionView.visibleCells.forEach { [weak self] cellItem in
            guard let self = self,
                  let cell = cellItem as? CharacterSelectionCell,
                  let indexPath = collectionView.indexPath(for: cell),
                  let layoutAttributes = collectionView.layoutAttributesForItem(at: indexPath)
            else { return }
            
            UIView.animate(withDuration: 0.2) {
                if layoutAttributes.frame.contains(self.centerPoint) {
                    cell.setCellHighlightStatus(isHighlighted: true)
                } else {
                    cell.setCellHighlightStatus(isHighlighted: false)
                }
            }
        }
    }

    
}
