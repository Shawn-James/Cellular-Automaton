// Copyright © 2020 Shawn James. All rights reserved.
// OnboardingController.swift

import UIKit

class OnboardingController: UIViewController {
    
    // MARK: - Properties
    
    let numberOfPages = 4
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.bounds = self.view.bounds
        view.center = self.view.center
        return view
    }()
    
    lazy var onboardingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = containerView.bounds
        scrollView.contentSize = CGSize(width: Int(containerView.frame.size.width)*numberOfPages, height: 0)
        scrollView.isPagingEnabled = true
        return scrollView
    }()
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(containerView)
        containerView.addSubview(onboardingScrollView)
        setupAllPages()
    }
    
    // MARK: - Handlers
    
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < numberOfPages else {
            self.dismiss(animated: true) {
                UserDefaults.standard.set(true, forKey: .notNewUser)
            }
            return
        }
        onboardingScrollView.setContentOffset(CGPoint(x: containerView.frame.size.width*CGFloat(button.tag), y: 0), animated: true)
    }
    
    // MARK: - Helper Methods
    
    private func setupAllPages() {
        for x in 0..<numberOfPages {
            // page
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * containerView.frame.size.width, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height))
            onboardingScrollView.addSubview(pageView)
            // image
            let imageView = UIImageView(frame: CGRect(x: 0, y: view.safeAreaInsets.top+50, width: pageView.frame.size.width, height: pageView.frame.size.height-205))
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: "onboarding\(x)")
            pageView.addSubview(imageView)
            // button
            let button = UIButton(frame: CGRect(x: 10, y: pageView.frame.size.height-view.safeAreaInsets.bottom-50, width: pageView.frame.size.width-20, height: 50))
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .red
            button.setTitle(x != (numberOfPages-1) ? "Next" : "Let's Go!", for: .normal)
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = x+1
            button.layer.cornerRadius = 25
            pageView.addSubview(button)
        }
    }
    
}

// MARK: - Live Previews

#if DEBUG
import SwiftUI

struct OnboardingControllerPreviews: PreviewProvider {
    static var previews: some View {
        let viewController = OnboardingController()
        
        return viewController.view.livePreview.edgesIgnoringSafeArea(.all)
    }
}

#endif
