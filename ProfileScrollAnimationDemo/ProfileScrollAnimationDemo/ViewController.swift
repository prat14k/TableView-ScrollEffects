//
//  ViewController.swift
//  ProfileScrollAnimationDemo
//
//  Created by Prateek Sharma on 24/01/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let nameFontSize : CGFloat = 20
    let baseUserNameFontSize : CGFloat = 1
    let userNameFontSize : CGFloat = 17
    let baseNameFontSize : CGFloat = 14
    
    let headerImageMaxCompress : CGFloat = 60
    
    var headerHght : CGFloat = 230
    let maxDecreaseScroll : CGFloat = 80
    
    let maxIncreaseScroll : CGFloat = 60
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet var tableViewHeader : TableHeader!
    
    var decreaseTableHeaderHeight : CGFloat = 0
    
    var currentScaleVal : CGFloat! = 0
    
    
    var headerViewTopConstraint : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let nib = UINib(nibName: "HeaderView", bundle: nil)
//        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "header")
        
        self.tableView.addSubview(tableViewHeader)
        
        headerHght = self.tableViewHeader.frame.size.height
        
        tableViewHeader.frame = CGRect(x: 0, y: -headerHght, width: self.tableView.frame.size.width, height: headerHght)
        
        tableViewHeader.translatesAutoresizingMaskIntoConstraints = false
        headerViewTopConstraint = NSLayoutConstraint(item: tableViewHeader, attribute: .top, relatedBy: .equal, toItem: tableView, attribute: .top, multiplier: 1, constant: -headerHght)
        
        tableView.addConstraint(headerViewTopConstraint)
        tableView.addConstraint(NSLayoutConstraint(item: tableViewHeader, attribute: .width, relatedBy: .equal, toItem: tableView, attribute: .width, multiplier: 1, constant: 0))
        tableView.addConstraint(NSLayoutConstraint(item: tableViewHeader, attribute: .centerX, relatedBy: .equal, toItem: tableView, attribute: .centerX, multiplier: 1, constant: 0))
        
        self.tableView.contentInset = UIEdgeInsets(top: headerHght, left: 0, bottom: 0, right: 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -headerHght)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Title \(indexPath.row)"
        return cell
    }
 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let bottomContraintVal = headerHght - (tableViewHeader.name.frame.origin.y + tableViewHeader.name.frame.size.height)
        
        tableViewHeader.headerViewBottomContraint = NSLayoutConstraint(item: tableViewHeader, attribute: .bottom, relatedBy: .equal, toItem: tableViewHeader.name, attribute: .bottom, multiplier: 1, constant: bottomContraintVal)
        tableViewHeader.addConstraint(tableViewHeader.headerViewBottomContraint)
        
        tableViewHeader.removeConstraint(tableViewHeader.userNameVheaderViewBottomContraint)
    }
    
}


extension ViewController : UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y + headerHght
        var scaleVal : CGFloat
        var binaryScaleVal : CGFloat = 1
        
        var newSizeMainLblSize : CGFloat = 0
        var newSizeSubLblSize : CGFloat = 0
        var headerViewBottomConstraintVal : CGFloat = 0
        
        if offsetY >= maxDecreaseScroll {
            scaleVal = maxDecreaseScroll
            binaryScaleVal = 0
            newSizeSubLblSize = baseUserNameFontSize
            newSizeMainLblSize = baseNameFontSize
            headerViewBottomConstraintVal = tableViewHeader.baseBottomContraintValue
        }
        else if offsetY <= 0 {
            scaleVal = 0
            binaryScaleVal = 1
            newSizeMainLblSize = nameFontSize
            newSizeSubLblSize = userNameFontSize
            headerViewBottomConstraintVal = tableViewHeader.headerViewBottomContraintConstant
        }
        else {
            scaleVal = offsetY
            binaryScaleVal = 1 - offsetY/maxDecreaseScroll
            newSizeSubLblSize = baseUserNameFontSize + ((userNameFontSize - baseUserNameFontSize) * (1 - (offsetY/maxDecreaseScroll)))
            newSizeMainLblSize = baseNameFontSize + ((nameFontSize - baseNameFontSize) * (1 - (offsetY/maxDecreaseScroll)))
            
            headerViewBottomConstraintVal = tableViewHeader.baseBottomContraintValue + ((tableViewHeader.headerViewBottomContraintConstant - tableViewHeader.baseBottomContraintValue) * (1 - (offsetY/maxDecreaseScroll)))
        }
        
        self.headerViewTopConstraint.constant = -headerHght + offsetY
        self.view.layoutIfNeeded()
        
        var transformOffset : CGFloat = offsetY
        if transformOffset < 0 {
            if transformOffset < -maxIncreaseScroll {
                transformOffset = -maxIncreaseScroll
            }
            
            let transformVal = (-transformOffset/(maxIncreaseScroll*2.5)) + 1
            let transform = CGAffineTransform(scaleX: transformVal, y: transformVal)
            
            UIView.animate(withDuration: 0.1, animations: {
                self.tableViewHeader.transform = transform
            })
        }
        else{
            UIView.animate(withDuration: 0.06, animations: {
                self.tableViewHeader.transform = CGAffineTransform.identity
            })
        }
        
        if currentScaleVal == scaleVal {
            return;
        }
        
        currentScaleVal = scaleVal
        tableViewHeader.userImageHghtContraint.constant = tableViewHeader.userImageHghtConstant - (headerImageMaxCompress * (currentScaleVal / maxDecreaseScroll))
        
        tableViewHeader.headerViewBottomContraint.constant = headerViewBottomConstraintVal
        
        UIView.animate(withDuration: 0.07, animations: {
            self.tableViewHeader.name.font = UIFont(name: "Times New Roman", size: newSizeMainLblSize)
            self.tableViewHeader.userName.font = UIFont(name: "Times New Roman", size: newSizeSubLblSize)
            self.tableViewHeader.userName.alpha = binaryScaleVal
            
            self.tableViewHeader.layoutIfNeeded()
        }) { (finished) in
            
        }
        
        //        if scrollView.panGestureRecognizer.translation(in: view).y < 0 {
        //            print("down")
        //
        //        }
        //        else{
        //            print("Up")
        //
        //        }
    
    }
    
}
