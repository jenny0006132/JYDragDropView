//
//  ViewController.swift
//  JYDragDropView
//
//  Created by Jenny Yao on 2017/1/18.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dragDropView = JYDragDropView(frame: view.frame, viewCount: 5)
        view.addSubview(dragDropView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

