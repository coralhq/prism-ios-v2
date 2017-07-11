//
//  ChatViewController.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/8/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismAnalytics
import PrismCore

class ChatViewController: BaseViewController {
    
    @IBOutlet var barView: UIView!
    @IBOutlet var tableView: ChatTableView!
    
    var chatManager: ChatManager
    var queryManager: ChatQueryManager?
    
    init() {
        chatManager = ChatManager()
        
        super.init(nibName: nil, bundle: Bundle.prism)
        
        guard let context = chatManager.coredata?.context else { return }
        queryManager = ChatQueryManager(context: context)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let composer = ChatComposer.composerFromNib(with: chatManager.accessToken) else { return }
        composer.delegate = self
        composer.addTo(view: barView, margin: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
      
        tableView.register(ChatHeaderCell.NIB, forCellReuseIdentifier: ChatHeaderCell.className())
        
        chatManager.connect { [weak self] (success, error) in
            guard success else { return }
            self?.chatManager.subscribe(completionHandler: { (success, error) in
                guard success else { return }
            })
        }
        
        queryManager?.delegate = self
        queryManager?.fetchSections()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        PrismAnalytics.shared.sendTracker(withEvent: .chatScreen)
    }
}

extension ChatViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = queryManager?.sections {
            return sections.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = queryManager?.sections,
            let objects = sections[section].objects {
            return objects.count + 1 //1 for header
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sections = queryManager!.sections
        let section = sections[indexPath.section]
        let objects = section.objects!
        
        if indexPath.row == objects.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatHeaderCell.className()) as! ChatHeaderCell
            cell.titleLabel.text = section.indexTitle
            return cell
        }
        
        let viewModel = objects[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.reuseIdentifier(viewModel: viewModel))
        if cell == nil {
            cell = ChatCell(viewModel: viewModel)
        }
        return cell!
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

extension ChatViewController: ChatComposerDelegate {
    func chatComposer(composer: ChatComposer, didSendText text: String) {
        chatManager.sendMessage(text: text)
    }
    
    func chatComposer(composer: ChatComposer, didSendSticker sticker: StickerViewModel) {
        
    }
}

extension ChatViewController: ChatQueryManagerDelegate {
    func didChange() {
        tableView.endUpdates()
    }
    
    func willChange() {
        tableView.beginUpdates()
    }
    
    func changedSection(at section: Int, changeType: ChatChangeType) {
        switch changeType {
        case .delete:
            tableView.deleteSections(IndexSet(integer: section), with: .fade)
        case .insert:
            tableView.insertSections(IndexSet(integer: section), with: .fade)
        default:
            tableView.reloadSections(IndexSet(integer: section), with: .none)
        }
    }
    
    func changedObject(at indexPath: IndexPath?, newIndexPath: IndexPath?, changeType: ChatChangeType) {
        
        guard let newIndexPath = newIndexPath else { return }
        
        switch changeType {
        case .delete:
            tableView.deleteRows(at: [newIndexPath], with: .fade)
        case .insert:
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .move:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .bottom)
            tableView.insertRows(at: [newIndexPath], with: .top)
        default:
            tableView.reloadRows(at: [newIndexPath], with: .none)
        }
    }
}

class EmptyChatView: UIView {
    @IBOutlet var titleLabel: UILabel!
}

class ChatTableView: UITableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
        transform = CGAffineTransform(scaleX: 1, y: -1)
    }
}
