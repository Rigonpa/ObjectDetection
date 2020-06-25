//
//  CollectionViewController.swift
//  ObjectDetection
//
//  Created by Ricardo González Pacheco on 12/06/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 250, height: 20))
        bar.autocapitalizationType = .none
        bar.barStyle = .default
        return bar
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.headerReferenceSize = CGSize(width: 0, height: 20)
        flowLayout.footerReferenceSize = CGSize(width: 0, height: 20)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        flowLayout.itemSize = CGSize(width: 160, height: 160)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.register(Item.self, forCellWithReuseIdentifier: Item.itemIdentifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let viewModel: CollectionViewModel
    init(viewModel: CollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        setupUI()
        
        viewModel.loadCollection()
    }
    
    private func setupUI() {
        if UserDefaults.standard.bool(forKey: CollectionViewModel.customCatalog) == true {
            title = ""
            searchBar.placeholder = "Enter key word"
            
            self.navigationItem.leftBarButtonItems = [
                UIBarButtonItem(title: "Back    ", style: .plain, target: self, action: #selector(handleBackButtonPressed)),
                UIBarButtonItem(customView: searchBar)
            ]
            self.navigationItem.rightBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchObject))
        }
        
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc private func handleSearchObject() {
        viewModel.searchButtonPressed(word: searchBar.text)
    }
    
    @objc private func handleBackButtonPressed() {
        UserDefaults.standard.removeObject(forKey: CollectionViewModel.customCatalog)
        viewModel.backButtonPressed()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(indexPath: indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: Item.itemIdentifier, for: indexPath) as? Item,
            let itemViewModel = viewModel.viewModel(indexPath: indexPath) else { fatalError() }
        item.viewModel = itemViewModel
        return item
    }
}

extension CollectionViewController: CollectionViewDelegate {
    func showAlert() {
        self.showAlert("Images containing that object were not found")
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
    }
}
