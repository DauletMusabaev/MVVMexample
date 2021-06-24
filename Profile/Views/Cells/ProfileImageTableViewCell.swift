//
//  ProfileImageTableViewCell.swift
//  OneFit
//
//  Created by Abzal on 22.01.2019.
//  Copyright © 2019 Codebusters. All rights reserved.
//

import Kingfisher
import Reusable
import RxSwift
import UIKit

class ProfileImageTableViewCell: UITableViewCell, MVVMView, NibReusable {
    var viewModel: ProfileImageViewModelProtocol! {
        didSet {
            configureBindings()
        }
    }

    private var disposeBag = DisposeBag()

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    private func configureBindings() {
        viewModel?.profileName.subscribe(onNext: { [weak self] profileName in
            self?.profileNameLabel.text = profileName
        }).disposed(by: disposeBag)

        viewModel?.imageURL.subscribe(onNext: { [weak self] imageURL in
            self?.profileImageView.kf.setImage(with: imageURL) { result in
                switch result {
                case .failure: self?.profileImageView.image = #imageLiteral(resourceName: "profile-image-default")
                default: break
                }
            }
        }).disposed(by: disposeBag)

        viewModel?.isAnimating.subscribe(onNext: { [weak self] isAnimating in
            isAnimating ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
        }).disposed(by: disposeBag)

        profileImageView.gestureRecognizers?.removeAll()
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(profileImageClicked(_:)))
        gestureRecognizer.minimumPressDuration = 0
        profileImageView.addGestureRecognizer(gestureRecognizer)
    }

    @objc private func profileImageClicked(_ recognizer: UILongPressGestureRecognizer) {
        guard let recognizedView = recognizer.view,
            let superView = recognizedView.superview else { return }

        let point = recognizer.location(in: superView)
        switch recognizer.state {
        case .began:
            recognizedView.alpha = 0.5
        case .changed:
            recognizedView.alpha = recognizedView.frame.contains(point) ? 0.5 : 1
        case .ended:
            if recognizedView.frame.contains(point) {
                viewModel.changePhoto()
            }

            fallthrough
        default:
            recognizedView.alpha = 1
        }
    }
}
