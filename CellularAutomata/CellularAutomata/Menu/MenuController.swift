// Copyright © 2020 Shawn James. All rights reserved.
// MenuController.swift

import UIKit

private let reuseIdentifier = "MenuTableViewCell"

class MenuController: UIViewController {
    
    // MARK: - Properties

    var delegate: MenuControllerDelegate?
    
    lazy var saveButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(
            title: "+ Save Current",
            style: .plain,
            target: self, action: #selector(handleSaveButtonPress))
        return barButton
    }()
    
    lazy var conwayHeader: MenuHeader = {
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        return MenuHeader(frame: frame)
    }()
    
    lazy var menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.frame = view.frame
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigation bar
        navigationItem.title = "Presets"
        navigationController?.navigationBar.prefersLargeTitles = true
        // bar buttons
        navigationItem.rightBarButtonItem = saveButton
        // settings table view
        view.addSubview(menuTableView)
        menuTableView.tableHeaderView = conwayHeader
        menuTableView.tableFooterView = UIView() // this just eliminates all the extra lines for the empty cells
    }
    
    // MARK: - Handlers
    
    @objc private func handleSaveButtonPress() {
        print("Save")
    }
    
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
        case .user: return UserPresetOptions.allCases.count
        case .standard: return StandardPresetOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuTableViewCell
        guard let section = MenuSections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .user:
            let preset = UserPresetOptions(rawValue: indexPath.row)
            cell.sectionType = preset
        case .standard:
            let setting = StandardPresetOptions(rawValue: indexPath.row)
            cell.sectionType = setting
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = MenuSections(rawValue: indexPath.section) else { return }
        
        exitMenu {
            switch section {
            case .user:
                let selection = UserPresetOptions(rawValue: indexPath.row)!
                delegate?.handleUserPresetSelection(selection)
            case .standard:
                let selection = StandardPresetOptions(rawValue: indexPath.row)!
                delegate?.handleStandardPresetSelection(selection)
            }
        }
        
    }
    
    private func exitMenu(completion: () -> ()) {
        navigationController?.popViewController(animated: true)
        completion()
    }
    
}

protocol MenuControllerDelegate {
    func handleUserPresetSelection(_ selection: UserPresetOptions)
    func handleStandardPresetSelection(_ selection: StandardPresetOptions)
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
