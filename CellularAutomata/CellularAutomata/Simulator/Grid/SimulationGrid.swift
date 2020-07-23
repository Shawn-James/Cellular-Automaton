// Copyright © 2020 Shawn James. All rights reserved.
// SimulationGrid.swift

import UIKit

class SimulationGrid: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - Properties
    
    let grid: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        grid.delegate = self
        grid.dataSource = self
        
        self.addSubview(grid)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Collection View Data Source

extension SimulationGrid: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}

#if DEBUG
import SwiftUI

struct SimulationGridPreviews: PreviewProvider {
    static var previews: some View {
        let collectionView = SimulationGrid()
        
        return collectionView.livePreview
    }
}

#endif
