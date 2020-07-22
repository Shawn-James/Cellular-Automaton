//  Copyright © 2020 Shawn James. All rights reserved.
//  SimulatorController.swift

import UIKit

class SimulatorController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
    
    // MARK: - Handlers
    
    // MARK: - Helper Methods

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
