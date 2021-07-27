//
//  MovieDataSource.swift
//  MovieApp
//
//  Created by George Digmelashvili on 7/23/21.
//

import UIKit

class CollectionViewDataSource<CellType,ViewModel>: NSObject, UICollectionViewDataSource where CellType: UICollectionViewCell {
    
    private let cellIdentifier: String
    var item: [ViewModel]
    private let configureCell: (CellType, ViewModel) -> ()
    
    init(cellIdentifier: String, item: [ViewModel], configureCell: @escaping (CellType, ViewModel) -> ()){
        self.cellIdentifier = cellIdentifier
        self.item = item
        self.configureCell = configureCell
        
    }
    
    func updateItem(_ item: [ViewModel]){
        self.item = item
    }
    
    func removeAll(){
        self.item.removeAll()
    }
    
    func removeItem(at index: Int){
        self.item.remove(at: index)
    }
    
    func appendItem(_ item: [ViewModel]){
        self.item.append(contentsOf: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.item.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? CellType else {
            fatalError("\(self.cellIdentifier) not found")
        }
        let vm = self.item[indexPath.row]
        self.configureCell(cell, vm)
        return cell
    }
    
    
}