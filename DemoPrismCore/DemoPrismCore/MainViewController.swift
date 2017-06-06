//
//  MainViewController.swift
//  DemoPrismCore
//
//  Created by fanni suyuti on 5/29/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class MainViewController: UIViewController {
    
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var idTextField:UITextField!
    @IBOutlet var conenctButton:UIButton!
    @IBOutlet var uploadButton:UIButton!
    @IBOutlet var simpleImageView:UIImageView!
    
    var connectResponse: ConnectResponse?
    var createConversationResponse: CreateConversationResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PrismCore.shared.configure(environment: EnvironmentType.Sandbox, merchantID: "62ccf49f-0386-49a3-858c-70c98a9dc4fc", delegate: self)
        
        uploadButton.isEnabled = false
    }
    
    @IBAction func visitorConnect(_ sender: UIButton) {
        sender.setTitle("Loading..", for: .normal)
        view.isUserInteractionEnabled = false
        
        guard let name = nameTextField.text, let identifier = idTextField.text else { return }
        
        PrismCore.shared.visitorConnect(visitorName: name, userID: identifier) { [weak self] (connectResponse, error) in
            
            sender.setTitle("Connect", for: .normal)
            self?.view.isUserInteractionEnabled = true
            
            self?.connectResponse = connectResponse
            
            if let response = connectResponse {
                PrismCore.shared.createConversation(visitorName: response.visitor.name, token: response.oAuth.accessToken) { (createConversationResponse, error) in
                    self?.createConversationResponse = createConversationResponse
                    
                    self?.uploadButton.isEnabled = true
                    
                    if let error = error as NSError? {
                        print("error: \(error)")
                    } else if let response = createConversationResponse {
                        self?.createConversationResponse = response
                        print("success \(response.conversation)")
                    }
                }
            } else if let error = error as? PrismError {
                print("prism error: \(error)")
            } else if let error = error {
                print("error: \(error)")
            }
        }
    }
    
    @IBAction func uploadPressed(sender:UIButton) -> Void {
        if let connect = connectResponse, let conversation = createConversationResponse {
            PrismCore.shared.getAttachmentURL(filename: "test-persebaya.jpg", conversationID: conversation.conversation.id, token: connect.oAuth.accessToken, completionHandler: { (url, error) in
                guard let image = self.simpleImageView.image else { return }
                guard let imageData = UIImagePNGRepresentation(image), let imageURL = url?.uploadURL else { return }
                PrismCore.shared.uploadAttachment(with: imageData, url: imageURL, completionHandler: { (success, error) in
                    
                })
            })
        }
    }
}

extension MainViewController: PrismCoreDelegate {
    func didReceive(message data: Data, in topic: String) {
        
    }
}
