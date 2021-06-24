//
//  ProfileAchievementsTableViewCell.swift
//  OneFit
//
//  Created by Abzal on 25.01.2019.
//  Copyright © 2019 Codebusters. All rights reserved.
//

import Reusable
import RxSwift
import UIKit

class ProfileAchievementsTableViewCell: UITableViewCell, MVVMView, NibReusable {
    private struct Constants {}

    // MARK: - Outlets

    @IBOutlet var collectionView: UICollectionView!

    // MARK: - Variables

    var disposeBag = DisposeBag()
    var viewModel: ProfileAchievementsViewModelProtocol! {
        didSet {
            configureCollectionView()
            configureBinding()
        }
    }

    // MARK: - Configuration

    private func configureBinding() {
        viewModel?.shouldUpdateCollectionView.subscribe(onNext: { [weak self] should in
            if should {
                self?.collectionView.reloadData()
            }
        }).disposed(by: disposeBag)
    }

    private func configureCollectionView() {
        collectionView.register(cellType: ProfileAchievementsCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    // MARK: - Actions

    @IBAction func showAllAchievements(_: Any) {
        viewModel.openAchievements()
    }
}

extension ProfileAchievementsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.achievements.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ProfileAchievementsCollectionViewCell.self)

        cell.achievement = viewModel.achievements[indexPath.row]

        return cell
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 24
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let viewWidth = collectionView.frame.width
        let viewHeight = collectionView.frame.height

        return CGSize(width: (viewWidth - 48) / 3.0, height: viewHeight)
    }
}
