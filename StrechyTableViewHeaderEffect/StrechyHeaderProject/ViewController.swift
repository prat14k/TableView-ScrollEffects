//
//  ViewController.swift
//  StrechyHeaderProject
//
//  Created by Prateek Sharma on 30/12/17.
//  Copyright © 2017 Prateek Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var headerView : StrechyHeaderView!
    var headerMaskLayer : CAShapeLayer!
    
    lazy var headerHieght : CGFloat! = {
       return   ((self.view.bounds.size.height * 3) / 4)
    }()
    let headerCutAwayHght : CGFloat! = 40.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView = tableView.tableHeaderView as! StrechyHeaderView
        tableView.tableHeaderView = nil
        
        let effectiveHieght = headerHieght - ( headerCutAwayHght / 2 )
        tableView.contentInset = UIEdgeInsets(top: effectiveHieght, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -effectiveHieght)
    
        headerView.frame = CGRect(x: 0, y: -effectiveHieght, width: view.frame.size.width, height: headerHieght)
        
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.black.cgColor
        headerView.layer.mask = headerMaskLayer
        
        tableView.addSubview(headerView)
        
        updateHeaderViewRect()
    }
    
    func updateHeaderViewRect(){
        
        let effectiveHeight = headerHieght - (headerCutAwayHght / 2)
        
        if tableView.contentOffset.y < -effectiveHeight {
            headerView.frame.origin.y = tableView.contentOffset.y
            headerView.frame.size.height = -tableView.contentOffset.y + (headerCutAwayHght / 2)
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: headerView.frame.width, y: 0))
        path.addLine(to: CGPoint(x: headerView.frame.size.width, y: headerView.frame.size.height))
        path.addLine(to: CGPoint(x: 0, y: headerView.frame.size.height - headerCutAwayHght))
        
        headerMaskLayer?.path = path.cgPath
    }
    
}


extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Cell no. \(indexPath.row)"
        return cell
    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderViewRect()
    }
}

