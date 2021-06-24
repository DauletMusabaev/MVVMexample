//
//  ProfileAchievementsCollectionViewCell.swift
//  OneFit
//
//  Created by Abzal on 25.01.2019.
//  Copyright © 2019 Codebusters. All rights reserved.
//

import Kingfisher
import Reusable
import UIKit

class ProfileAchievementsCollectionViewCell: UICollectionViewCell, NibReusable {
    // MARK: - Outlets

    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!

    // MARK: - Variables

    var achievement: Achievement! {
        didSet {
            updateUI()
        }
    }

    // MARK: - Configurations

    private func updateUI() {
        descriptionLabel.text = achievement.name

        guard let url = URL(string: achievement.logoURL) else { return }
        logoImageView.kf.setImage(with: url)
    }
}
