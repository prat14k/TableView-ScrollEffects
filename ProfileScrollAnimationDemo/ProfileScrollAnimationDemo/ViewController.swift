//
//  ViewController.swift
//  ProfileScrollAnimationDemo
//
//  Created by Prateek Sharma on 24/01/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var upperHeaderView: UIView!
    @IBOutlet weak var headerImageHieghtContraint: NSLayoutConstraint! {
        didSet {
            headerImageHght = headerImageHieghtContraint.constant
        }
    }
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint! {
        didSet {
            uibottomConstant = bottomContraint.constant
        }
    }
    
    @IBOutlet weak var imageVMainLblContraint: NSLayoutConstraint! {
        didSet {
            uiimageVMainLblConstant = imageVMainLblContraint.constant
        }
    }
    @IBOutlet weak var mainVSubLblContraint: NSLayoutConstraint! {
        didSet {
            uimainVSubLblConstant = mainVSubLblContraint.constant
        }
    }
    
    
    var currentScaleVal : CGFloat! = 0
    var headerImageHght : CGFloat!
    
    var uibottomConstant : CGFloat!
    var uiimageVMainLblConstant : CGFloat!
    var uimainVSubLblConstant : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
    
}


extension ViewController : UIScrollViewDelegate {

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        var scaleVal : CGFloat
        var binaryScaleVal : CGFloat = 1
        var mainLabelTransform : CGAffineTransform
        var subLabelTransform : CGAffineTransform
        
        var bottomContraintConst :CGFloat = 0
        var imageVmainLblDist :CGFloat = 0
        var mainVSubLblDist :CGFloat = 0
        
        
        if offsetY >= 50 {
            scaleVal = 50
            binaryScaleVal = 0
            mainLabelTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            subLabelTransform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            bottomContraintConst = -4
            imageVmainLblDist = 0
            mainVSubLblDist = 0
        }
        else if offsetY <= 0 {
            scaleVal = 0
            binaryScaleVal = 1
            mainLabelTransform = CGAffineTransform.identity
            subLabelTransform = CGAffineTransform.identity
            bottomContraintConst = uibottomConstant
            imageVmainLblDist = uiimageVMainLblConstant
            mainVSubLblDist = uimainVSubLblConstant
            
//            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
        else {
            scaleVal = offsetY
            binaryScaleVal = 1 - offsetY/50
            mainLabelTransform = CGAffineTransform(scaleX: (0.7 + (0.3 * (1 - offsetY/50))), y: (0.7 + (0.3 * (1 - offsetY/50))))
            subLabelTransform = CGAffineTransform(scaleX: (0.5 + (0.5 * (1 - offsetY/50))), y: (0.5 + (0.5 * (1 - offsetY/50))))
            bottomContraintConst = uibottomConstant * (1 - offsetY/50)
            imageVmainLblDist = uiimageVMainLblConstant * (1 - offsetY/50)
            mainVSubLblDist = uimainVSubLblConstant * (1 - offsetY/50)
            
//            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
        
        if currentScaleVal == scaleVal {
            return;
        }
        
        currentScaleVal = scaleVal
        
//        if scrollView.panGestureRecognizer.translation(in: view).y < 0 {
//            print("down")
//            
//        }
//        else{
//            print("Up")
//            
//        }
        
        imageVMainLblContraint.constant = imageVmainLblDist
        mainVSubLblContraint.constant = mainVSubLblDist
        bottomContraint.constant = bottomContraintConst
        headerImageHieghtContraint.constant = headerImageHght - currentScaleVal
        UIView.animate(withDuration: 0.07, animations: {
            self.mainLabel.transform = mainLabelTransform
            self.subLabel.transform = subLabelTransform
            self.subLabel.alpha = binaryScaleVal
            self.view.layoutIfNeeded()
        }) { (finished) in
            
        }
        
        
    }
    
}
