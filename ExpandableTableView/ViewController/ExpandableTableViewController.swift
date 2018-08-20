//
//  ExpandableTableViewController.swift
//  ExpandableTableView
//
//  Created by Lucas Nascimento on 19/08/18.
//  Copyright © 2018 Lucas Nascimento. All rights reserved.
//

import UIKit

class ExpandableTableViewController: UIViewController {

    private var mainView: ExpandableView?
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        mainView = ExpandableView(frame: view.frame)
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FAQ"
    }
}

