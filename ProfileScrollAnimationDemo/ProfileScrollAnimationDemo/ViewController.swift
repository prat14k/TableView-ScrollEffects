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
    let baseUserNameFontSize : CGFloat = 8
    let userNameFontSize : CGFloat = 17
    let baseNameFontSize : CGFloat = 14
    
    let headerImageMaxCompress : CGFloat = 60
    
    var headerHght : CGFloat = 230
    let maxDecreaseScroll : CGFloat = 80
    
    let maxIncreaseScroll : CGFloat = 60
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet var tableViewHeader : TableHeader!
//    var headerView : TableHeader!
    
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
        
        
//        tableView.addConstraint(NSLayoutConstraint(item: tableViewHeader, attribute: <#T##NSLayoutAttribute#>, relatedBy: <#T##NSLayoutRelation#>, toItem: tableView, attribute: <#T##NSLayoutAttribute#>, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>))
//        tableView.addConstraint(NSLayoutConstraint(item: tableViewHeader, attribute: <#T##NSLayoutAttribute#>, relatedBy: <#T##NSLayoutRelation#>, toItem: tableView, attribute: <#T##NSLayoutAttribute#>, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>))
//        tableView.addConstraint(NSLayoutConstraint(item: tableViewHeader, attribute: <#T##NSLayoutAttribute#>, relatedBy: <#T##NSLayoutRelation#>, toItem: tableView, attribute: <#T##NSLayoutAttribute#>, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>))
        
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
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        if headerView == nil {
//            if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? TableHeader {
//                
//                headerView = header
//                headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: headerHght - decreaseTableHeaderHeight)
//                headerView.contentView.backgroundColor = UIColor(red: 148.0/255.0, green: 188.0/255.0, blue: 252.0/255.0, alpha: 1.0)
//
//            }
//        }
//        return headerView
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return headerHght - decreaseTableHeaderHeight
//    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        
//    }
    
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
            headerViewBottomConstraintVal = -1
        }
        else if offsetY <= 0 {
//            print(offsetY)
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
            
            headerViewBottomConstraintVal = tableViewHeader.headerViewBottomContraintConstant * (1 - (offsetY/maxDecreaseScroll))
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
