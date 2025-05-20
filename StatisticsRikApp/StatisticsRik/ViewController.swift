//
//  ViewController.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 19.05.2025.
//

import UIKit
import BuisnessLayer

class ViewController: UIViewController {

    let statisticsService = StatisticsService()

    override func viewDidLoad() {
        super.viewDidLoad()
        statisticsService.loadData()
        view.backgroundColor = .gray
    }

}
