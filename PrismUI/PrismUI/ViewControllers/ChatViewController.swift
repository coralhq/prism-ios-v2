//
//  ChatViewController.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/8/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class ChatViewController: BaseViewController {
    
    @IBOutlet var barView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var viewModel: ChatViewModel
    
    init(credential: PrismCredential) {
        viewModel = ChatViewModel(credential: credential)
        
        super.init(nibName: nil, bundle: Bundle.prism)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let composer = ChatComposer.viewFromNib() as? ChatComposer else { return }
        composer.delegate = self
        composer.translatesAutoresizingMaskIntoConstraints = false
        barView.addSubview(composer)
        barView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[composer]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["composer": composer]))
        barView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[composer]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["composer": composer]))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension UITableView {
    func reusableCell(withConfig config: ChatCellConfig) -> ChatCell? {
        return self.dequeueReusableCell(withIdentifier: ChatCell.reuseIdentifier(config: config)) as? ChatCell
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var config: ChatCellConfig!
        
        if indexPath.row == 0 {
            config = ChatCellConfig(cellType: .In, contentType: .Text)
        } else if indexPath.row == 1 {
            config = ChatCellConfig(cellType: .Out, contentType: .Text)
        } else if indexPath.row == 2 {
            config = ChatCellConfig(cellType: .In, contentType: .Product)
        } else if indexPath.row == 3 {
            config = ChatCellConfig(cellType: .Out, contentType: .Product)
        } else if indexPath.row == 4 {
            config = ChatCellConfig(cellType: .In, contentType: .Sticker)
        } else if indexPath.row == 5 {
            config = ChatCellConfig(cellType: .Out, contentType: .Sticker)
        } else if indexPath.row == 6 {
            config = ChatCellConfig(cellType: .In, contentType: .Cart)
        } else if indexPath.row == 7 {
            config = ChatCellConfig(cellType: .Out, contentType: .Cart)
        } else if indexPath.row == 8 {
            config = ChatCellConfig(cellType: .In, contentType: .Invoice)
        } else if indexPath.row == 9 {
            config = ChatCellConfig(cellType: .Out, contentType: .Invoice)
        } else if indexPath.row == 10 {
            config = ChatCellConfig(cellType: .In, contentType: .Image)
        } else {
            config = ChatCellConfig(cellType: .Out, contentType: .Image)
        }
        
        var cell = tableView.reusableCell(withConfig: config)
        if cell == nil {
            cell = ChatCell(config: config)
        }
        return cell!
    }
}

extension ChatViewController: ChatComposerDelegate {
    func chatComposer(composer: ChatComposer, didSend chatText: String) {
        print("send chat \(chatText)")
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

class EmptyChatView: UIView {
    @IBOutlet var titleLabel: UILabel!
}
