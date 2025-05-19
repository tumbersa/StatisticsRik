//
//  ViewController.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 19.05.2025.
//

import UIKit
import NetworkLayer

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let a = Fetcher()
        a.ff()
        view.backgroundColor = .gray
    }

}

