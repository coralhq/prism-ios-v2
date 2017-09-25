//
//  ChatViewController.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/8/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore
import UserNotifications

class ChatViewController: BaseViewController {
    
    @IBOutlet var barView: UIView!
    @IBOutlet var tableView: ChatTableView!
    @IBOutlet var connectLabel: UILabel!
    
    let authViewModel = AuthViewModel()
    let chatManager: ChatManager = ChatManager()
    var queryManager: ChatQueryManager?
    
    init() {
        super.init(nibName: nil, bundle: Bundle.prism)
        
        let context = chatManager.coredata.mainContext
        queryManager = ChatQueryManager(context: context)
        queryManager?.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addComposer()
        
        tableView.backgroundColor = Settings.shared.theme.buttonColor.withAlphaComponent(0.05)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatHeaderCell.NIB, forCellReuseIdentifier: ChatHeaderCell.className())
        tableView.register(CloseChatTableViewCell.NIB, forCellReuseIdentifier: CloseChatTableViewCell.className())
        
        queryManager?.fetchSections()
        
        addWelcomeMessageIfEmpty()
    }
    
    deinit {
        print("\(self) deinitialized")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        PrismAnalytics.shared.sendTracker(withEvent: .chatScreen)
    }
    
    func addComposer() {
        guard let composer = ChatComposer.composerFromNib(with: Vendor.shared.credential!.accessToken) else {
            return
        }
        composer.delegate = self
        composer.addTo(view: barView, margin: 0)
    }
    
    func removeComposer() {
        for subView in barView.subviews {
            subView.removeFromSuperview()
        }
    }
    
    func addWelcomeMessageIfEmpty() {
        if let count = queryManager?.sections.count,
            count == 0 {
            connectLabel.text = Settings.shared.texts.welcomeMessage
            connectLabel.isHidden = false
        } else {
            connectLabel.isHidden = true
        }
    }
}

extension UITableView {
    func isViewModel(vm: ChatViewModel, extensionFrom prevVM: ChatViewModel?) -> Bool {
        if let prevVM = prevVM,
            vm.senderID == prevVM.senderID {
            return true
        } else {
            return false
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = queryManager?.sections {
            if sections.count > 0 {
                tableView.backgroundView = nil
            } else {
                tableView.backgroundView = EmptyChatView.viewFromNib()
            }            
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = queryManager?.sections,
            let objects = sections[safe: section]?.objects {
            return objects.count + 1 //add 1 for header
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
        if let closeChatViewModel = viewModel.contentViewModel as? ContentCloseChatViewModel {
            removeComposer()
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CloseChatTableViewCell.className()) as! CloseChatTableViewCell
            cell.configure(viewModel: closeChatViewModel)
            cell.delegate = self
            return cell
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.reuseIdentifier(viewModel: viewModel)) as? ChatCell
        if cell == nil {
            cell = ChatCell(viewModel: viewModel)
        }
        
        let isExtension = tableView.isViewModel(vm: viewModel, extensionFrom: objects[safe: indexPath.row + 1])
        cell?.chatView?.update(with: viewModel, isExtension: isExtension)
        
        return cell!
    }
}

extension ChatViewController: CloseChatTableViewCellDelegate {
    func reconnectTapped(sender: UIButton) {
        view.isUserInteractionEnabled = false
        sender.startLoading(indicatorColor: Settings.shared.theme.buttonColor)
        
        authViewModel.visitorConnect() { [weak self] (error) in
            self?.view.isUserInteractionEnabled = true
            sender.stopLoading()
            
            if let error = error {
                print("Error: \(error)")
            } else {
                self?.addComposer()
                self?.chatManager.coredata.clearData()
                self?.queryManager?.fetchSections()
                self?.tableView.reloadData()
            }
        }
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
    func chatComposer(composer: ChatComposer, didComposeText text: String) {
        chatManager.sendMessage(text: text)
    }
    
    func chatComposer(composer: ChatComposer, didPickSticker sticker: StickerViewModel) {
        chatManager.sendMessage(sticker: sticker)
    }
    
    func chatComposer(composer: ChatComposer, didPickImage image: UIImage, imageName: String) {
        chatManager.sendMessage(image: image, imageName: imageName, state: .start)
    }
}

extension ChatViewController: ChatQueryManagerDelegate {
    func didChange() {
        addWelcomeMessageIfEmpty()
        
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
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.insertRows(at: [newIndexPath], with: .none)
        default:
            tableView.reloadRows(at: [newIndexPath], with: .none)
        }
    }
}

class ChatTableView: UITableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
        transform = CGAffineTransform(scaleX: 1, y: -1)
    }
}
