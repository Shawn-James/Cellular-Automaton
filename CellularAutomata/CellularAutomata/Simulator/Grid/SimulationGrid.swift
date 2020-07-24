// Copyright © 2020 Shawn James. All rights reserved.
// SimulationGrid.swift

import UIKit

private let reuseIdentifier = "SimulationGridCell"

class SimulationGrid: UIView {
    // MARK: - Properties
    
    let columnCount: CGFloat = 9 // This is too small for fingers, but MVP requires it to be min 25
    lazy var rowCount: CGFloat = { (grid.frame.height / cellSize.height).rounded(.awayFromZero) }() // go slightly higher to avoid gap
    
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
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 1

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBlue
        collectionView.allowsMultipleSelection = false
        collectionView.register(SimulationGridCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        grid.delegate = self
        grid.dataSource = self
        
        addSubview(grid)
        grid.topAnchor.constraint(equalTo: topAnchor).isActive = true
        grid.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        grid.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        grid.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SimulationGrid: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SimulationGridCell else { return UICollectionViewCell() }
        cell.backgroundColor = cell.isAlive ? .white : .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SimulationGridCell else { return }
        print(indexPath)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SimulationGridCell else { return }
//        cell.isAlive.toggle()
//        cell.backgroundColor = cell.isAlive ? .white : .black
//    }
    
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

struct SimulationGridPreviews: PreviewProvider {
    static var previews: some View {
        let view = SimulationGrid()
        
        return view.livePreview
    }
}

#endif
