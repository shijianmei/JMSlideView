//
//  ViewController.swift
//  SwiftExample
//
//  Created by jianmei on 2023/3/31.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
        // Do any additional setup after loading the view.
        let slideView = JMSlideView(frame: CGRectMake(0, kScreenH-200, kScreenW, 160))
        slideView.topH = 100
        self.view.addSubview(slideView)
    }


}

