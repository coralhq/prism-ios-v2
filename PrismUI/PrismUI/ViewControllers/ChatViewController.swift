//
//  ChatViewController.swift
//  PrismUI
//
//  Created by fanni suyuti on 6/12/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

open class ChatViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var welcomeMessageLabel: UILabel!
    
    var welcomeMessage: String = ""
    var navTitle: String = ""
    var subtitle: String = ""
    var avatar: URL?
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: Bundle.prism)
    }
    
    convenience public init(avatar: URL, title: String, subtitle: String, wellcomeMessage: String) {
        
        self.init(nibName: "ChatViewController", bundle: Bundle.init(identifier: "io.prismapp.PrismUI"))
        
        self.welcomeMessage = wellcomeMessage
        self.navTitle = title
        self.subtitle = subtitle
        self.avatar = avatar
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar(title: navTitle, subtitle: subtitle, avatar: avatar!)
        
        welcomeMessageLabel.text = welcomeMessage
        mainView.backgroundColor = Theme.shared.mainViewBackgroundColor
        
        welcomeMessageLabel.font = UIFont.welcomeMessageFont()
    }
}

extension ChatViewController {
    override func navigationItemDidTapLeftBarButtonItem() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.popViewController(animated: true)
    }
    
    override func navigationItemDidTapRightBarButtonItem() {}
}
