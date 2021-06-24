//
//  AboutAppViewModel.swift
//  OneFitDev
//
//  Created by Daulet Mussabayev on 21.01.2021.
//  Copyright © 2021 Codebusters. All rights reserved.
//

import Foundation
import RxSwift
import StoreKit
import Intercom

protocol AboutAppViewModelProtocol: MVVMViewModel {
    
    func connectWithTeam()
    func rateApplication()
}

class AboutAppViewModel: AboutAppViewModelProtocol {
    
    var router: MVVMRouter
    
    //MARK: - Methods
    
    init(router: MVVMRouter) {
        self.router = router
    }
    
    func rateApplication() {
        if let url = URL(string: "https://itunes.apple.com/app/id1375903148?action=write-review/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    func connectWithTeam() {
        Intercom.presentMessenger()
    }
}
