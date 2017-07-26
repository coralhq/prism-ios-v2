//
//  OfflineMessageViewController.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/18/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class OfflineMessageViewController: BaseViewController {
    @IBOutlet var offlineMessageLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!

    init() {
        super.init(nibName: nil, bundle: Bundle.prism)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Settings.shared.theme.headerColor.withAlphaComponent(0.05)
        
        titleLabel.text = "Terimakasih telah menghubungi kami".localized()
        offlineMessageLabel.text = Settings.shared.offlineWidget.offlineMessageConfirmation
    }
}
