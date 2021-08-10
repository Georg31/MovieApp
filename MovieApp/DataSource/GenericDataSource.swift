//
//  MovieDataSource.swift
//  MovieApp
//
//  Created by George Digmelashvili on 7/23/21.
//

import UIKit

class CollectionViewDataSource<CellType, ViewModel>: NSObject, UICollectionViewDataSource where CellType: UICollectionViewCell {

    private let cellIdentifier: String
    private var item: [ViewModel]
    private let configureCell: (CellType, ViewModel) -> Void

    init(cellIdentifier: String, item: [ViewModel], configureCell: @escaping (CellType, ViewModel) -> Void) {
        self.cellIdentifier = cellIdentifier
        self.item = item
        self.configureCell = configureCell

    }

    func count() -> Int {
        return self.item.count
    }

    func atIndex(_ index: IndexPath) -> ViewModel {
        return self.item[index.row]
    }

    func updateItem(_ item: [ViewModel]) {
        self.item = item
    }

    func removeAll() {
        self.item.removeAll()
    }

    func removeItem(at index: Int) {
        self.item.remove(at: index)
    }

    func appendItem(_ item: [ViewModel]) {
        self.item.append(contentsOf: item)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.item.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? CellType else {
            fatalError("\(self.cellIdentifier) not found")
        }
        let viewM = self.item[indexPath.row]
        self.configureCell(cell, viewM)
        return cell
    }

}
