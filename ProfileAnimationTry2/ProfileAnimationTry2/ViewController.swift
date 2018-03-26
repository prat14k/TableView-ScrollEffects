//
//  ViewController.swift
//  ProfileAnimationTry2
//
//  Created by Prateek Sharma on 12/03/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var prevScaleValue : CGFloat = 1
    
    
    let minScrollScale : CGFloat = 0.6
    let maxScrollScale : CGFloat = 1.2
    
    let maxIncreaseScrollDist : CGFloat = 80
    let maxDecreaseScrollDist : CGFloat = 100
    
    var tableHeaderViewTopConstraint : NSLayoutConstraint!
    
    var tableHeaderViewHghtConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableHeaderView : CustomView!
    var headerHght : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let headerView = Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)?.first as? CustomView {
            
            tableHeaderView = headerView
            tableView.addSubview(headerView)
            
            self.tableHeaderView.setNeedsLayout()
            self.tableHeaderView.layoutIfNeeded()
            
            headerHght = self.tableHeaderView.frame.size.height
            
            self.tableHeaderView.translatesAutoresizingMaskIntoConstraints = false
            
            tableHeaderViewTopConstraint = NSLayoutConstraint(item: self.tableHeaderView, attribute: .top, relatedBy: .equal, toItem: self.tableView, attribute: .top, multiplier: 1.0, constant: -20-headerHght)
            
            
            self.tableView.addConstraint(NSLayoutConstraint(item: self.tableHeaderView, attribute: .centerX, relatedBy: .equal, toItem: self.tableView, attribute: .centerX, multiplier: 1.0, constant: 0))
            self.tableView.addConstraint(NSLayoutConstraint(item: self.tableHeaderView, attribute: .width, relatedBy: .equal, toItem: self.tableView, attribute: .width, multiplier: 1.0, constant: 0))
            self.tableView.addConstraint(tableHeaderViewTopConstraint)
            
            self.tableView.addConstraint(NSLayoutConstraint(item: self.tableHeaderView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self.tableView, attribute: .top, multiplier: 1.0, constant: -20))
            
            tableHeaderViewHghtConstraint = NSLayoutConstraint(item: self.tableHeaderView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: headerHght)
            
            
            self.tableView.contentInset = UIEdgeInsets(top: headerHght+20, left: 0, bottom: 0, right: 0)
            self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: headerHght+20, left: 0, bottom: 0, right: 0)
            self.tableView.contentOffset = CGPoint(x: 0, y: -headerHght-20)
        
        }
        
        
        
    }

}

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    
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
     
        let offsetY = scrollView.contentOffset.y + headerHght + 20
        
        var scaleValue : CGFloat = 1
        
        
        if offsetY == 0 {
            scaleValue = 1
        }
        else
        if offsetY >= maxDecreaseScrollDist{
            scaleValue = minScrollScale
        }
        else if offsetY <= -maxIncreaseScrollDist {
            scaleValue = maxScrollScale
        }
        else if offsetY > 0 {
            scaleValue = minScrollScale + ((1 - minScrollScale) * ((maxDecreaseScrollDist - offsetY) / maxDecreaseScrollDist))
        }
        else if offsetY < 0 {
            scaleValue = 1 + ((maxScrollScale - 1) * ((-offsetY) / maxIncreaseScrollDist))
        }
        
        
        self.tableHeaderViewTopConstraint.constant = scrollView.contentOffset.y
        self.tableView.layoutIfNeeded()
        
        if prevScaleValue == scaleValue {
            return
        }
        
        prevScaleValue = scaleValue
        
        UIView.animate(withDuration: 0.03, animations: { 
            self.tableHeaderView.innerView.transform = CGAffineTransform(scaleX: scaleValue, y: scaleValue)
            self.tableView.layoutIfNeeded()
        }) { (finished) in
            
        }
        
    }
    
}

