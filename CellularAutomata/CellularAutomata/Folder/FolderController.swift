// Copyright © 2020 Shawn James. All rights reserved.
// FolderController.swift

import UIKit

private let reuseIdentifier = "FolderTableViewCell"

class FolderController: UIViewController {
    // MARK: - Properties

    lazy var folderTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(FolderTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.frame = view.frame
        return tableView
    }()
    
    lazy var conwayHeader: FolderTableViewHeader = {
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        return FolderTableViewHeader(frame: frame)
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigation bar
        navigationItem.title = "Presets"
        // settings table view
        view.addSubview(folderTableView)
        folderTableView.tableHeaderView = conwayHeader
        folderTableView.tableFooterView = UIView() // this just eliminates all the extra lines for the empty cells
    }
    
    // MARK: - Handlers
    
    // MARK: - Helper Methods
    
}

// MARK: - Table View

extension FolderController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return FolderSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .darkGray
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = FolderSections(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = FolderSections(rawValue: section) else { return 0 }
        switch section {
        case .presets: return PresetOptions.allCases.count
        case .settings: return SettingsOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = folderTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FolderTableViewCell
        guard let section = FolderSections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .presets:
            let preset = PresetOptions(rawValue: indexPath.row)
            cell.sectionType = preset
        case .settings:
            let setting = SettingsOptions(rawValue: indexPath.row)
            cell.sectionType = setting
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = FolderSections(rawValue: indexPath.section) else { return }
        
        switch section {
        case .presets:
            print(PresetOptions(rawValue: indexPath.row)!.description)
        case .settings:
            print(SettingsOptions(rawValue: indexPath.row)!.description)
        }
    }
    
}

// MARK: - Live Previews

#if DEBUG
import SwiftUI

struct FolderControllerPreview: PreviewProvider {
    static var previews: some View {
        let viewController = FolderController()
        
        return viewController.view.livePreview.edgesIgnoringSafeArea(.all)
    }
}

#endif
