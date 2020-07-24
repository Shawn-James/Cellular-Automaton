// Copyright © 2020 Shawn James. All rights reserved.
// FolderTableViewHeader.swift

import UIKit

class FolderTableViewHeader: UIView {
    // MARK: - Properties
    
    let conwayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "JohnConway")
        return imageView
    }()
    
    let conwayNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Tribute to John Horton Conway"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "December, 26 1937 - April, 11 2020"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let profileImageDimension: CGFloat = 60
        // profile image view
        addSubview(conwayImageView)
        conwayImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        conwayImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        conwayImageView.widthAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        conwayImageView.heightAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        conwayImageView.layer.cornerRadius = profileImageDimension / 2
        // username label
        addSubview(conwayNameLabel)
        conwayNameLabel.centerYAnchor.constraint(equalTo: conwayImageView.centerYAnchor, constant: -10).isActive = true
        conwayNameLabel.leftAnchor.constraint(equalTo: conwayImageView.rightAnchor, constant: 12).isActive = true
        // email label
        addSubview(subtitleLabel)
        subtitleLabel.centerYAnchor.constraint(equalTo: conwayImageView.centerYAnchor, constant: 10).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: conwayImageView.rightAnchor, constant: 12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Live Previews

#if DEBUG
import SwiftUI

struct FolderTableViewHeaderViewPreviews: PreviewProvider {
    static var previews: some View {
        let view = FolderTableViewHeader()
        
        return view.livePreview
    }
}

#endif
