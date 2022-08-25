//
//  NKUICollectionView.swift
//  NKUtility
//
//  Created by Hunt on 2021/11/7.
//

import UIKit

open class NKUICollectionView: UICollectionView {
    
    public init() {
        let layout = NKUICollectionView.getLayout(direction: .vertical)
        super.init(frame: .zero, collectionViewLayout: layout)
    }
    
    public init(direction: UICollectionView.ScrollDirection) {
        let layout = NKUICollectionView.getLayout(direction: direction)
        super.init(frame: .zero, collectionViewLayout: layout)
    }
    
    fileprivate static func getLayout(direction: UICollectionView.ScrollDirection) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
