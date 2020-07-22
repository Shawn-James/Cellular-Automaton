//  Copyright © 2020 Shawn James. All rights reserved.
//  SimulatorController.swift

import UIKit

class SimulatorController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
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
