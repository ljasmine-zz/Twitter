//
//  ProfileView.swift
//  Twitter
//
//  Created by jasmine_lee on 11/7/16.
//  Copyright © 2016 jasmine_lee. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!

    var username: String? {
        get { return usernameLabel.text }
        set { usernameLabel.text = username }
    }

    var bannerImage: UIImage? {
        get { return bannerImageView.image }
        set { bannerImageView.image = bannerImage }
    }

    var profileImage: UIImage? {
        get { return profileImageView.image }
        set { profileImageView.image = profileImage }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "ProfileView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
