//
//  AboutAppViewController.swift
//  OneFitDev
//
//  Created by Daulet Mussabayev on 21.01.2021.
//  Copyright © 2021 Codebusters. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import StoreKit

class AboutAppViewController: ViewController, MVVMView {
    

    //MARK: - Variables
    
    var viewModel: AboutAppViewModel!
    let disposeBag = DisposeBag()

    
    // MARK: - Outlets
    
    private lazy var logoImage: UIImageView = {
        let logo = UIImageView()
        logo.image = Assets.whiteLogo.image.withRenderingMode(.alwaysTemplate)
        logo.tintColor = UIColor(hex: 0x8391A1)
        return logo
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = L10n.AboutApp.description
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var rateAppButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(L10n.AboutApp.rateApp, for: .normal)
        btn.backgroundColor = UIColor(hex: 0x2B63F3)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(self.rateAppWasPressed(sender:)), for:
                        .touchUpInside)
        return btn
    }()
    
    private lazy var connectUsButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(L10n.AboutApp.callAdministration, for: .normal)
        btn.backgroundColor = UIColor(hex: 0xF2F5FE)
        btn.setTitleColor(UIColor(hex: 0x2B63F3), for: .normal)
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.main.cgColor
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(self.connectUsWasPressed(sender:)), for:
                        .touchUpInside)
        return btn
    }()
    
    private lazy var connectUsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = L10n.AboutApp.callAdministrationDescription
        label.textColor = UIColor(hex: 0x51657B)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var boxView: UIView = {
        let box = UIView()
        box.backgroundColor = UIColor(hex: 0xF2F5FE)

        return box
    }()
    
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            label.text = L10n.AboutApp.version(version)
        }
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.markup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationBar()
    }

    //MARK: - Configurations
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
        navigationItem.title = L10n.AboutApp.title
    }
    
    //MARK: - Markup
    
    private func markup() {
        
        [boxView, logoImage, descriptionLabel, rateAppButton,
        connectUsLabel, connectUsButton, versionLabel ].forEach { view.addSubview($0) }
        
        
        self.logoImage.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(self.view).offset(200)
        }
        self.descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.logoImage.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.centerX.equalTo(self.view)
        }
        self.rateAppButton.snp.makeConstraints {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(20)
            $0.height.equalTo(48)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        self.connectUsButton.snp.makeConstraints {
            $0.top.equalTo(self.rateAppButton.snp.bottom).offset(20)
            $0.height.equalTo(48)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        self.connectUsLabel.snp.makeConstraints {
            $0.top.equalTo(self.connectUsButton.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)

        }
        self.boxView.snp.makeConstraints {
            $0.edges.equalTo(self.view)
        }
        self.versionLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.view.snp.bottom).inset(30)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
    }
    //MARK: - Actions
    
    @objc func rateAppWasPressed(sender: UIButton){
        viewModel.rateApplication()
    }
    
    @objc func connectUsWasPressed(sender: UIButton) {
        viewModel.connectWithTeam()
    }

}
