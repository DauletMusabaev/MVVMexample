//
//  ProfileImageViewModel.swift
//  OneFit
//
//  Created by Abzal on 22.01.2019.
//  Copyright © 2019 Codebusters. All rights reserved.
//

import Foundation

import PromiseKit
import RxCocoa
import RxSwift

protocol ProfileImageViewModelProtocol: MVVMViewModel {
    var imageURL: BehaviorRelay<URL?> { get }
    var profileName: BehaviorRelay<String> { get }
    var isAnimating: BehaviorRelay<Bool> { get }

    func changePhoto()
}

class ProfileImageViewModel: ProfileImageViewModelProtocol {
    // MARK: - Properties

    var router: MVVMRouter

    let imageURL = BehaviorRelay<URL?>(value: nil)
    let profileName = BehaviorRelay<String>(value: "")
    let isAnimating = BehaviorRelay<Bool>(value: false)

    // MARK: - Methods

    func changePhoto() {
        let context = ProfileRouter.RouteType.changePhoto { [weak self] image in
            guard let `self` = self else { return }
            self.isAnimating.accept(true)

            firstly {
                return UserGeneralService.shared.uploadImage(image)
            }.then { response -> Promise<UserGeneralService.UpdateUserResponse> in
                guard
                    let newUser = UserSessionManager.shared.user.copy()
                else { throw StandardError.copyingError }

                newUser.image = response.image
                return UserGeneralService.shared.updateUser(newUser)
            }.done { response in
                self.imageURL.accept(response.user.image?.url)
            }.catch { error in
                let context = ProfileRouter.RouteType.error(message: error.localizedDescription) {}
                self.router.enqueueRoute(with: context)
            }.finally {
                self.isAnimating.accept(false)
            }
        }

        router.enqueueRoute(with: context)
    }

    // MARK: - Method

    init(router: MVVMRouter, profileName: String, imageURL: URL?) {
        self.router = router
        self.imageURL.accept(imageURL)
        self.profileName.accept(profileName)
    }
}
