//
//  CollectionViewModel.swift
//  ObjectDetection
//
//  Created by Ricardo González Pacheco on 12/06/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

protocol CollectionCoordinatorDelegate {
    func itemSelected(itemViewModel: ItemViewModel)
    func backButtonWasPressed()
}

protocol CollectionViewDelegate {
    func showAlert()
    func updateCollectionView()
}

class CollectionViewModel{
    
    static var customCatalog: String = "Custom catalog"
    
    let group = DispatchGroup()
    
    var itemViewModels = [ItemViewModel]()
    var filteredItemViewModels = [ItemViewModel]()
    
    let coreMLPrediction = CoreMLPrediction()
    
    var coordinatorDelegate: CollectionCoordinatorDelegate?
    var viewDelegate: CollectionViewDelegate?
    
    func loadCollection() {
        itemViewModels.removeAll(keepingCapacity: true)
        for each in 0...99 {
            if each < 10 {
                guard let image = UIImage(named: "0\(each)ImageNumber") else { return }
                itemViewModels.append(ItemViewModel(image: image))
            } else {
                guard let image = UIImage(named: "\(each)ImageNumber") else { return }
                itemViewModels.append(ItemViewModel(image: image))
            }
        }
    }
    
    func searchButtonPressed(word: String?) {
        filteredItemViewModels.removeAll(keepingCapacity: false)
        for (index, unprocessedItemViewModel) in itemViewModels.enumerated() {
            var coincidencesCount: Int = 0
            print(index)
            
            group.enter()
            self.coreMLPrediction.predict(unprocessedItemViewModel) { [weak self] processedItemViewModel in
                guard let self = self else { return }
                coincidencesCount = 0
                for name in processedItemViewModel.objectsNames {
                    if name == word {
                        coincidencesCount += 1
                    }
                }
                if coincidencesCount > 0 {
                    self.filteredItemViewModels.append(processedItemViewModel)
                }
                self.group.leave()
            }
            
            // print("Me estoy ejecutando sin esperar al .predict, Con lo que quiere decir
            // q el for no está esperando a que .predict devuelva algo y sigue iterando")
            // Obviamente el for no te va a esperar. Oblígalo a esperarte
            print("Waiting for mlmodel to detect objects in the image")
            group.wait()
        }
        // Y esto se ejecutará antes de que el for haya recibido todas las respuestas de predict, lo que te
        // vas a actualizar el colectionview y no has recibido respuestas aún o no
        // las has recibido todas
        // sleep(50)
        self.viewDelegate?.updateCollectionView()
        if filteredItemViewModels.count == 0 {
            self.viewDelegate?.showAlert()
        }
    }
    
    func backButtonPressed() {
        coordinatorDelegate?.backButtonWasPressed()
    }
    
    func didSelectItem(indexPath: IndexPath) {
        if !UserDefaults.standard.bool(forKey: CollectionViewModel.customCatalog) {
            coordinatorDelegate?.itemSelected(itemViewModel: itemViewModels[indexPath.item])
        } else {
            coordinatorDelegate?.itemSelected(itemViewModel: filteredItemViewModels[indexPath.item])
        }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems() -> Int {
        if !UserDefaults.standard.bool(forKey: CollectionViewModel.customCatalog) {
            return itemViewModels.count
        } else {
            return filteredItemViewModels.count
        }
    }
    
    func viewModel(indexPath: IndexPath) -> ItemViewModel? {
        if !UserDefaults.standard.bool(forKey: CollectionViewModel.customCatalog) {
            return itemViewModels[indexPath.item]
        } else {
            return filteredItemViewModels[indexPath.item]
        }
    }
}
