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
        let ctaButton = UIButton()
        ctaButton.setTitle("CTA", for: .normal)
        ctaButton.addTarget(self, action: #selector(ctaButtonTap), for: .touchUpInside)
        view.addSubview(ctaButton)
        
        ctaButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ctaButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ctaButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ctaButton.widthAnchor.constraint(equalToConstant: 100),
            ctaButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc
    func ctaButtonTap() {
        // MARK: create call tag action
        let tagAction = CinnoxAction.initTagAction(tagId: "YOUR_TAG_ID", contactMethod: .message)
        
        // MARK: create call staff action
        // let staffAction = CinnoxAction.initStaffAction(staffEid: "YOUR_STAFF_EID", contactMethod: .message)
        
        // MARK: create open directory action
        // let directoryAction = CinnoxAction.initDirectoryAction()
        CinnoxVisitorCore.current?.callToAction(action: tagAction, completion: { error in
            print(error)
        })
    }
}

