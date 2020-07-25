// Copyright © 2020 Shawn James. All rights reserved.
// MenuController.swift

import UIKit

private let reuseIdentifier = "MenuTableViewCell"

class MenuController: UIViewController {
    // MARK: - Properties

    lazy var menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.frame = view.frame
        return tableView
    }()
    
    lazy var conwayHeader: MenuHeader = {
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        return MenuHeader(frame: frame)
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigation bar
        navigationItem.title = "Menu"
        // settings table view
        view.addSubview(menuTableView)
        menuTableView.tableHeaderView = conwayHeader
        menuTableView.tableFooterView = UIView() // this just eliminates all the extra lines for the empty cells
    }
    
    // MARK: - Handlers
    
    // MARK: - Helper Methods
    
}

// MARK: - Table View

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return MenuSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .red
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = MenuSections(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = MenuSections(rawValue: section) else { return 0 }
        switch section {
        case .presets: return PresetOptions.allCases.count
        case .settings: return SettingsOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuTableViewCell
        guard let section = MenuSections(rawValue: indexPath.section) else { return UITableViewCell() }
        
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
        guard let section = MenuSections(rawValue: indexPath.section) else { return }
        
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

struct MenuControllerPreviews: PreviewProvider {
    static var previews: some View {
        let viewController = MenuController()
        
        return viewController.view.livePreview.edgesIgnoringSafeArea(.all)
    }
}

#endif
