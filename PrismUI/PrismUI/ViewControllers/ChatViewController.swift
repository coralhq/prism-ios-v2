//
//  ChatViewController.swift
//  PrismUI
//
//  Created by fanni suyuti on 6/12/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

public class ChatViewController: BaseViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var welcomeMessageLabel: UILabel!
    
    var welcomeMessage: String = ""
    var navTitle: String = ""
    var subtitle: String = ""
    var avatar: URL?
    
    private var viewModel: ChatViewModel
    
    init(credential: PrismCredential) {
        self.viewModel = ChatViewModel(credential: credential)
        
        super.init(nibName: nil, bundle: Bundle.prism)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.connect { (success, error) in
            if success {
                print("connect chat success")
            } else {
                guard let error = error as NSError? else { return }
                print("error: \(error)")
            }
        }
        
        viewModel.subscribe { (success, error) in
            if success {
                print("subscribe chat success")
            } else {
                guard let error = error as NSError? else { return }
                print("error: \(error)")
            }
        }
    }
}

extension ChatViewController {
    override func navigationItemDidTapLeftBarButtonItem() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.popViewController(animated: true)
    }
    
    override func navigationItemDidTapRightBarButtonItem() {}
}
