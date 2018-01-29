//
//  View1Controller.swift
//  ProfileScrollAnimationDemo
//
//  Created by Prateek Sharma on 29/01/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class View1Controller: UIViewController , UIScrollViewDelegate{

    @IBOutlet weak var testingLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var lastOffset : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: 0, height: 400)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var offsetY = scrollView.contentOffset.y
        let size : CGFloat = 60
        var newSize : CGFloat
        if offsetY <= 0 {
            offsetY = 0
            newSize = size
        }
        else if offsetY >= 50 {
            offsetY = 50
            newSize = size - 50
        }
        else {
            newSize = (10 + (50 * (1 - (offsetY / 50))))
        }
        
        if offsetY == lastOffset {
            return
        }
        
        print(newSize)
        
        UIView.animate(withDuration: 0.07) { 
            self.testingLabel.font = UIFont(name: "Times New Roman", size: newSize)
        }
    }

}
