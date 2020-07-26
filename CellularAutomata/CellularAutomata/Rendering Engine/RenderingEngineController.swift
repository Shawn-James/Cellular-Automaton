//  Copyright © 2020 Shawn James. All rights reserved.
//  RenderingEngineController.swift

import UIKit

private let segueIdentifier = "OpenMenuController"

class RenderingEngineController: UIViewController {
    // MARK: - Properties
        
    let gridView = GridView()
    lazy var resetButton: UIButton = createNewButton(withTitle: "Reset.")
    lazy var goButton: UIButton = createNewButton(withTitle: "Go!")
    
    lazy var menuBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.turn.up.right"),
            style: .plain,
            target: self, action: #selector(handleMenuButtonPress))
        return barButton
    }()
    
    lazy var backBarButton: UIBarButtonItem = { // this is declared on this controller but actually used on MenuController
        let barButton = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil)
        return barButton
    }()
    
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
        // nav bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .red
        // nav bar buttons
        navigationItem.rightBarButtonItem = menuBarButton
        navigationItem.backBarButtonItem = backBarButton
        let customBackButtonImage = UIImage(systemName: "arrowshape.turn.up.left")
        navigationController?.navigationBar.backIndicatorImage = customBackButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = customBackButtonImage
        // view
        view.backgroundColor = .white
        view.alpha = 0
        UIView.animate(withDuration: 2) {
            self.view.alpha = 1
        }
        // grid
        view.addSubview(gridView)
        gridView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gridView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        gridView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        gridView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
            gridView.timer?.invalidate()
            gridView.grid.reloadData()
            goButton.setTitle("Go!", for: .normal)
        case "Go!":
            gridView.startRendering()
            sender.setTitle("Pause", for: .normal)
        case "Pause":
            gridView.timer?.invalidate()
            sender.setTitle("Go!", for: .normal)
        default: break
        }
    }
    
    @objc private func handleMenuButtonPress() {
        let menuController = MenuController()
        navigationController?.pushViewController(menuController, animated: true)
    }
    
    // MARK: - Helper Methods
    
    private func createNewButton(withTitle inputTitle: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor(patternImage: UIImage(named: "GraphingPaper")!)
        button.setTitleColor(.black, for: .normal)
        button.setTitle(inputTitle, for: .normal)
        button.titleLabel?.font = UIFont(name: "Thin Pencil Handwriting", size: 18)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
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

struct RenderingEngineControllerPreviews: PreviewProvider {
    static var previews: some View {
        let viewController = RenderingEngineController()
        
        return viewController.view.livePreview.edgesIgnoringSafeArea(.all)
    }
}

#endif
