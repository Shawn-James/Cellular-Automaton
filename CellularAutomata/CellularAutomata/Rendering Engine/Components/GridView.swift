// Copyright © 2020 Shawn James. All rights reserved.
// GridView.swift

import UIKit

private let reuseIdentifier = "SimulationGridCell"

class GridView: UIView, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    var timer: Timer?
    var lastSelectedCell = IndexPath()
    var delegate: GridViewDelegate?
    
    var generationCount = 0 { // starts at zero
        didSet {
            delegate?.updateTitle(with: generationCount)
        }
    }
    
    let columnCount: CGFloat = 19 // MVP wants 25, but that is too small for fingers in iOS - this breaks at 20
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
    
    lazy var grid: UICollectionView = {
        // layout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 1
        // collection view (grid)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.canCancelContentTouches = false
        collectionView.allowsMultipleSelection = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBlue
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(toSelectCells:)))
        collectionView.addGestureRecognizer(panGesture)
        panGesture.delegate = self
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
    
    // MARK: - Handlers
    
    func startRendering() {
        let speed = 0.05 // seconds between each generation
        timer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(renderNextGeneration), userInfo: nil, repeats: true)
    }
    
    @objc func handlePanGesture(toSelectCells panGesture: UIPanGestureRecognizer) {
        let location: CGPoint = panGesture.location(in: grid)
        if let indexPath: IndexPath = grid.indexPathForItem(at: location) {
            if indexPath != lastSelectedCell {
                let cell = grid.cellForItem(at: indexPath)!
                
                DispatchQueue.main.async {
                    cell.backgroundColor = .black
                }
            }
            lastSelectedCell = indexPath
        }
    }
    
    // MARK: - Helper Methods
    
    @objc private func renderNextGeneration() {
        // mark cells for change
        var cells = [UICollectionViewCell : Int]()
        // find neighboards
        for cell in self.grid.visibleCells { // would need to figure out how to grab all cells to fix vertical wrap-around
            // current cell coordinates
            let indexPath = self.grid.indexPath(for: cell)!
            let x = indexPath.item
            let y = indexPath.section
            // neighbor coordinates (using an equation to handle wrap-around)
            let NW = IndexPath(item: (x-1 + Int(columnCount)) % Int(columnCount), section: (y-1 + Int(rowCount)) % Int(rowCount))
            let N = IndexPath(item: (x + Int(columnCount)) % Int(columnCount), section: (y-1 + Int(rowCount)) % Int(rowCount))
            let NE = IndexPath(item: (x+1 + Int(columnCount)) % Int(columnCount), section: (y-1 + Int(rowCount)) % Int(rowCount))
            let W = IndexPath(item: (x-1 + Int(columnCount)) % Int(columnCount), section: (y + Int(rowCount)) % Int(rowCount))
            let E = IndexPath(item: (x+1 + Int(columnCount)) % Int(columnCount), section: (y + Int(rowCount)) % Int(rowCount))
            let SW = IndexPath(item: (x-1 + Int(columnCount)) % Int(columnCount), section: (y+1 + Int(rowCount)) % Int(rowCount))
            let S = IndexPath(item: (x + Int(columnCount)) % Int(columnCount), section: (y+1 + Int(rowCount)) % Int(rowCount))
            let SE = IndexPath(item: (x+1 + Int(columnCount)) % Int(columnCount), section: (y+1 + Int(rowCount)) % Int(rowCount))
            // hold live neighbor count
            var liveCount = 0
            // count live neighbors
            for neighbor in [NW, N, NE, W, E, SW, S, SE] {
                let cell = self.grid.cellForItem(at: neighbor)
                if cell?.backgroundColor == UIColor.black {
                    liveCount += 1
                }
            }
            // mark for change
            cells[cell] = liveCount
        }
        // render updates using rules
        for element in cells {
            let cell = element.key
            let liveCount = element.value
            // rules
            if liveCount == 3 {
                cell.backgroundColor = .black
            } else if liveCount == 2 && cell.backgroundColor == .black {
                // do nothing
            } else {
                cell.backgroundColor = .white
            }
        }
        generationCount += 1 // update generation count
    }
    
}

protocol GridViewDelegate {
    func updateTitle(with generationCount: Int)
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
        AudioPlayer.shared.playSound("move")
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
