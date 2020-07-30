// Copyright © 2020 Shawn James. All rights reserved.
// MenuController.swift

import UIKit
import CoreData

private let reuseIdentifier = "MenuTableViewCell"

class MenuController: UIViewController {
    
    // MARK: - Properties

    var delegate: MenuControllerDelegate?
    var liveGrid: UICollectionView?
    
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
    
    lazy var saveAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "Enter a Preset Name",
            message: nil,
            preferredStyle: .alert)
        alert.addTextField { (textField) in textField.placeholder = "Preset Name..." }
        let inputText = alert.textFields?.first?.text
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { (_) in self.performSave(withName: alert.textFields?.first?.text) })
        return alert
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
    
    private lazy var fetchedResultsController: NSFetchedResultsController<UserPreset> = {
        let fetchRequest: NSFetchRequest<UserPreset> = UserPreset.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        let context = CoreDataManager.shared.mainContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error Fetching -> IncompleteTasksTableView in fetchedResultsController: \(error)")
        }
        return fetchedResultsController
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigation bar
        navigationItem.title = "Presets"
        navigationItem.largeTitleDisplayMode = .always
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
        present(saveAlert, animated: true)
    }
    
    // MARK: - Helper Methods
    
    private func performSave(withName name: String?) {
        guard let liveGrid = liveGrid else { return }
        let visibleCells = liveGrid.visibleCells
        let liveCells = visibleCells.filter { $0.backgroundColor == .black }
        // create presets
        let newPreset = UserPreset(name: name ?? "No Name")
        // save live cells to to preset
        for cell in liveCells {
            let indexPath = liveGrid.indexPath(for: cell)!
            let newCellPosition = CellPosition(x: indexPath.item, y: indexPath.section)
            newPreset.addToCells(newCellPosition)
        }
        CoreDataManager.shared.save()
    }
    
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
        view.layer.borderColor = UIColor.systemBackground.cgColor
        view.layer.borderWidth = 1
        
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
        case .user: return fetchedResultsController.fetchedObjects?.count ?? 0
        case .standard: return StandardPresetOptions.allCases.count
        case .appSettings: return AppSettingsOptions.allCases.count
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuTableViewCell
        guard let section = MenuSections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .user:
            let fetchedObjectName = fetchedResultsController.object(at: indexPath).name
            let setting = UserPresetOptions(description: fetchedObjectName ?? "No Name")
            cell.sectionType = setting
        case .standard:
            let setting = StandardPresetOptions(rawValue: indexPath.row)
            cell.sectionType = setting
        case .appSettings:
            let setting = AppSettingsOptions(rawValue: indexPath.row)
            cell.sectionType = setting
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = MenuSections(rawValue: indexPath.section) else { return }
        
        exitMenu {
            switch section {
            case .user:
                let selectedUserPreset = fetchedResultsController.object(at: indexPath)
                delegate?.handleUserPresetSelection(selectedUserPreset)
            case .standard:
                let selection = StandardPresetOptions(rawValue: indexPath.row)!
                delegate?.handleStandardPresetSelection(selection)
            case .appSettings:
                let selection = AppSettingsOptions(rawValue: indexPath.row)!
                delegate?.handleAppSettingSelection(selection)
            }
        }
    }
    
    private func exitMenu(completion: () -> ()) {
        navigationController?.popViewController(animated: true)
        completion()
    }
    
}

protocol MenuControllerDelegate {
    func handleUserPresetSelection(_ userPresetSelection: UserPreset)
    func handleStandardPresetSelection(_ selection: StandardPresetOptions)
    func handleAppSettingSelection(_ selection: AppSettingsOptions)
}

extension MenuController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        menuTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        menuTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            menuTableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            menuTableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            menuTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            menuTableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            menuTableView.deleteRows(at: [oldIndexPath], with: .automatic)
            menuTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            menuTableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
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
