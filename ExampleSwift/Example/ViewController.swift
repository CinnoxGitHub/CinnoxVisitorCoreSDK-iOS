//
//  ViewController.swift
//  Example
//
//  Created by Jimmy on 2023/7/16.
//

import UIKit
import CinnoxVisitorCoreSDK

class ViewController: UIViewController {

    var widget = CinnoxVisitorWidget(frame: .init(x: 100, y: 100, width: 50, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(widget)
    }

}

