//
//  HomeViewController.swift
//  ObjectDetection
//
//  Created by Ricardo González Pacheco on 09/06/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    static var switchOn: String = "Switch on"
    
    let catalogButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Catalog", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(handleCatalogSelected), for: .touchUpInside)
        return btn
    }()
    
    let customButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Custom", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(handleCustomSelected), for: .touchUpInside)
        return btn
    }()
    
    let mlSwitch: UISwitch = {
        let s = UISwitch(frame: .zero)
        s.translatesAutoresizingMaskIntoConstraints = false
        s.isOn = true
        s.isHidden = true
        s.addTarget(self, action: #selector(handleSwitchChanged), for: .valueChanged)
        return s
    }()
    
    let useVisionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.isHidden = true
        label.text = "Use Vision"
        return label
    }()
    
    let viewModel: HomeViewModel
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        UserDefaults.standard.setValue(false, forKeyPath: HomeViewController.switchOn)
        
        view.addSubview(catalogButton)
        view.addSubview(customButton)
        view.addSubview(mlSwitch)
        view.addSubview(useVisionLabel)
        
        NSLayoutConstraint.activate([
            catalogButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -70),
            catalogButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            catalogButton.widthAnchor.constraint(equalToConstant: 120),
            
            customButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 70),
            customButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            customButton.widthAnchor.constraint(equalToConstant: 120),
            
            mlSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mlSwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            
            useVisionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            useVisionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 140)
        ])
    }
    
    @objc private func handleCatalogSelected() {
        UserDefaults.standard.set(false, forKey: CollectionViewModel.customCatalog)
        viewModel.catalogSelected()
    }
    
    @objc private func handleCustomSelected() {
        UserDefaults.standard.set(true, forKey: CollectionViewModel.customCatalog)
        viewModel.customSelected()
    }
    
    @objc private func handleSwitchChanged() {
        UserDefaults.standard.setValue(mlSwitch.isOn, forKeyPath: HomeViewController.switchOn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeViewController: HomeViewDelegate {
    
}
