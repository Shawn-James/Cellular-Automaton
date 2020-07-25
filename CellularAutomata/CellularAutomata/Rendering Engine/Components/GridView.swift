// Copyright © 2020 Shawn James. All rights reserved.
// GridView.swift

import UIKit

private let reuseIdentifier = "SimulationGridCell"

class GridView: UIView {
    // MARK: - Properties

    let columnCount: CGFloat = 9 // MVP wants 25, but that is too small for fingers in iOS
    lazy var rowCount: CGFloat = { (frame.height / cellSize.height).rounded(.awayFromZero) }() // round up to avoid gap at bottom of screen
    
    lazy var cellSize: CGSize = {
        let itemSpacing: CGFloat = 1
        let cellPadding = itemSpacing * 2
        let width = (frame.width / columnCount) - cellPadding
        return CGSize(width: width, height: width) // same because square shape
    }()
    
    lazy var cellDimension: CGFloat = {
        (frame.width / columnCount) - 1
    }() // used for width or height
    
    let grid: UICollectionView = {
        // layout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 1
        // collection view (grid)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBlue
        collectionView.allowsMultipleSelection = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // view
//        UIView.setAnimationsEnabled(false) <- this can disable unwanted animations in collection view, but would also stop button animations on controller
        // delegates
        grid.delegate = self
        grid.dataSource = self
        // grid
        addSubview(grid)
        grid.topAnchor.constraint(equalTo: topAnchor).isActive = true
        grid.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        grid.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        grid.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        // autolayout
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GridView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(rowCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: frame.width, height: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(columnCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.backgroundColor = cell.backgroundColor == .white ? .black : .white // toggle color
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
}

// MARK: - Live Previews

#if DEBUG
import SwiftUI

struct GridViewPreviews: PreviewProvider {
    static var previews: some View {
        let view = GridView()
        
        return view.livePreview
    }
}

#endif
