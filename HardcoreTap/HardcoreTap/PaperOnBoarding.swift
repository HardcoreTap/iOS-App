//
//  PaperOnBoarding.swift
//  HardcoreTap
//
//  Created by Богдан Быстрицкий on 27/11/2017.
//  Copyright © 2017 Bogdan Bystritskiy. All rights reserved.
//

import UIKit
import SwiftyOnboard

class PaperOnBoarding: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        
        
        let swiftyOnboard = SwiftyOnboard(frame: view.frame)
        view.addSubview(swiftyOnboard)
        swiftyOnboard.dataSource = self
        
    }
    
    

    
}

extension PaperOnBoarding: SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 3
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let page = SwiftyOnboardPage()
        page.imageView = UIImageView(image: UIImage(named: "rules1"))
        return page
    }
}


