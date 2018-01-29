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
    let baseUserNameFontSize : CGFloat = 12
    let userNameFontSize : CGFloat = 17
    let baseNameFontSize : CGFloat = 14
    
    let headerHght : CGFloat = 230
    let maxScrollDecrease : CGFloat = 80
    
    @IBOutlet weak var tableView : UITableView!
    var headerView : TableHeader!
    
    var decreaseTableHeaderHeight : CGFloat = 0
    
    var currentScaleVal : CGFloat! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "HeaderView", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "header")
        
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if headerView == nil {
            if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? TableHeader {
                
                headerView = header
                headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: headerHght - decreaseTableHeaderHeight)
                headerView.contentView.backgroundColor = UIColor(red: 148.0/255.0, green: 188.0/255.0, blue: 252.0/255.0, alpha: 1.0)

            }
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHght - decreaseTableHeaderHeight
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        
//    }
    
}


extension ViewController : UIScrollViewDelegate {

    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        var scaleVal : CGFloat
        var binaryScaleVal : CGFloat = 1
        
        var newSizeMainLblSize : CGFloat = 0
        var newSizeSubLblSize : CGFloat = 0
        
        
        if offsetY >= maxScrollDecrease {
            scaleVal = maxScrollDecrease
            binaryScaleVal = 0
            newSizeSubLblSize = baseUserNameFontSize
            newSizeMainLblSize = baseNameFontSize
        }
        else if offsetY <= 0 {
            scaleVal = 0
            binaryScaleVal = 1
            newSizeMainLblSize = nameFontSize
            newSizeSubLblSize = userNameFontSize
        }
        else {
            scaleVal = offsetY
            binaryScaleVal = 1 - offsetY/maxScrollDecrease
            newSizeSubLblSize = baseUserNameFontSize + ((userNameFontSize - baseUserNameFontSize) * (1 - (offsetY/maxScrollDecrease)))
            newSizeMainLblSize = baseNameFontSize + ((nameFontSize - baseNameFontSize) * (1 - (offsetY/maxScrollDecrease)))
        }
        
        if currentScaleVal == scaleVal {
            return;
        }
        
        currentScaleVal = scaleVal
        
        headerView.userImageHghtContraint.constant = headerView.userImageHghtConstant - (60 * (currentScaleVal / maxScrollDecrease))
        
        var frame = headerView.frame
        frame.size.height = frame.size.height - currentScaleVal
        
        decreaseTableHeaderHeight = currentScaleVal
        
        
        
        UIView.animate(withDuration: 0.07, animations: {
            self.headerView.name.font = UIFont(name: "Times New Roman", size: newSizeMainLblSize)
            self.headerView.userName.font = UIFont(name: "Times New Roman", size: newSizeSubLblSize)
            self.headerView.userName.alpha = binaryScaleVal
            
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
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
    
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
//        let offsetY = scrollView.contentOffset.y
//        var scaleVal : CGFloat
//        var binaryScaleVal : CGFloat = 1
//        var mainLabelTransform : CGAffineTransform
//        var subLabelTransform : CGAffineTransform
//        
//        var bottomContraintConst :CGFloat = 0
//        var imageVmainLblDist :CGFloat = 0
//        var mainVSubLblDist :CGFloat = 0
//        
//        
//        if offsetY >= 50 {
//            scaleVal = 50
//            binaryScaleVal = 0
//            mainLabelTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//            subLabelTransform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//            bottomContraintConst = -4
//            imageVmainLblDist = 0
//            mainVSubLblDist = 0
//        }
//        else if offsetY <= 0 {
//            scaleVal = 0
//            binaryScaleVal = 1
//            mainLabelTransform = CGAffineTransform.identity
//            subLabelTransform = CGAffineTransform.identity
//            bottomContraintConst = uibottomConstant
//            imageVmainLblDist = uiimageVMainLblConstant
//            mainVSubLblDist = uimainVSubLblConstant
//            
////            scrollView.contentOffset = CGPoint(x: 0, y: 0)
//        }
//        else {
//            scaleVal = offsetY
//            binaryScaleVal = 1 - offsetY/50
//            mainLabelTransform = CGAffineTransform(scaleX: (0.7 + (0.3 * (1 - offsetY/50))), y: (0.7 + (0.3 * (1 - offsetY/50))))
//            subLabelTransform = CGAffineTransform(scaleX: (0.5 + (0.5 * (1 - offsetY/50))), y: (0.5 + (0.5 * (1 - offsetY/50))))
//            bottomContraintConst = uibottomConstant * (1 - offsetY/50)
//            imageVmainLblDist = uiimageVMainLblConstant * (1 - offsetY/50)
//            mainVSubLblDist = uimainVSubLblConstant * (1 - offsetY/50)
//            
////            scrollView.contentOffset = CGPoint(x: 0, y: 0)
//        }
//        
//        if currentScaleVal == scaleVal {
//            return;
//        }
//        
//        currentScaleVal = scaleVal
//        
////        if scrollView.panGestureRecognizer.translation(in: view).y < 0 {
////            print("down")
////            
////        }
////        else{
////            print("Up")
////            
////        }
//        
//        imageVMainLblContraint.constant = imageVmainLblDist
//        mainVSubLblContraint.constant = mainVSubLblDist
//        bottomContraint.constant = bottomContraintConst
//        headerImageHieghtContraint.constant = headerImageHght - currentScaleVal
//        UIView.animate(withDuration: 0.07, animations: {
//            self.mainLabel.transform = mainLabelTransform
//            self.subLabel.transform = subLabelTransform
//            self.subLabel.alpha = binaryScaleVal
//            self.view.layoutIfNeeded()
//        }) { (finished) in
//            
//        }
//        
        
//    }
    
}
