//  Copyright © 2020 Shawn James. All rights reserved.
//  SimulatorController.swift

import UIKit

class SimulatorController: UIViewController {
    // MARK: - Properties
    
    lazy var resetButton: UIButton = createButton(withTitle: "Reset.")
    lazy var goButton: UIButton = createButton(withTitle: "Go!")
    
    let hStackViewTop: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 45
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        // gear bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder.fill"), style: .plain, target: self, action: #selector(handleFolderButtonPress)) // why does the target not work if I add this as property at the top of this page?
        navigationItem.rightBarButtonItem?.tintColor = .darkGray
        // view
        view.backgroundColor = .white
        view.alpha = 0
        UIView.animate(withDuration: 2) {
            self.view.alpha = 1
        }
        // hStackView (Top)
        view.addSubview(hStackViewTop)
        hStackViewTop.heightAnchor.constraint(equalToConstant: 32).isActive = true
        hStackViewTop.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hStackViewTop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        // reset button
        hStackViewTop.addArrangedSubview(resetButton)
        resetButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        // play button
        hStackViewTop.addArrangedSubview(goButton)
        goButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    // MARK: - Handlers

    @objc private func handleButtonPress(sender: UIButton) {
        UIButton.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (_) in
            UIButton.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                sender.transform = CGAffineTransform.identity
            }, completion: nil)
        }
                
        switch sender.currentTitle {
        case "Reset.":
            print("Perform reset.")
        case "Go!":
            print("Start the simulation.")
        default:
            fatalError("Error: Default case was hit in handleButtonPress. It should never do that.")
        }
    }
    
    @objc private func handleFolderButtonPress() {
        print("Open Folder.")
    }
    
    // MARK: - Helper Methods
    
    private func createButton(withTitle inputTitle: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor(patternImage: UIImage(named: "GraphingPaper")!)
        button.setTitleColor(.black, for: .normal)
        button.setTitle(inputTitle, for: .normal)
        button.titleLabel?.font = UIFont(name: "Thin Pencil Handwriting", size: 18)
        button.layer.shadowColor = UIColor(red: 0.64, green: 0.71, blue: 0.78, alpha: 1.00).cgColor
        button.layer.shadowOffset = CGSize(width: 10, height: 10)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.8
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleButtonPress(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

}

// MARK: - Live Preview

#if DEBUG
import SwiftUI

struct SimulatorControllerLivePreview: PreviewProvider {
    static var previews: some View {
        let viewController = SimulatorController()
        
        return viewController.view.livePreview.edgesIgnoringSafeArea(.all)
    }
}

#endif
