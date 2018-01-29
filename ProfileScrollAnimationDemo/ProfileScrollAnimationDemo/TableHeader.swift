//
//  TableHeader.swift
//  ProfileScrollAnimationDemo
//
//  Created by Prateek Sharma on 29/01/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class TableHeader: UIView {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userName: UILabel!

    @IBOutlet weak var userImageHghtContraint: NSLayoutConstraint! {
        didSet {
            userImageHghtConstant = userImageHghtContraint.constant
        }
    }
    
    @IBOutlet weak var headerViewBottomContraint: NSLayoutConstraint! {
        didSet {
            headerViewBottomContraintConstant = headerViewBottomContraint.constant
        }
    }
    
    public var userImageHghtConstant : CGFloat!
    public var headerViewBottomContraintConstant : CGFloat!
}
