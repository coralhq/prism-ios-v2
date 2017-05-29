//
//  ViewController.swift
//  DemoPrismCore
//
//  Created by Nanang Rafsanjani on 5/24/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class ViewController: UIViewController {
    
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var idTextField:UITextField!
    @IBOutlet var conenctButton:UIButton!
    
    let prismCore = PrismCore(environment: EnvironmentType.Sandbox, merchantID: "62ccf49f-0386-49a3-858c-70c98a9dc4fc")
    var connectResponse: ConnectResponse?
    var createConversationResponse: CreateConversationResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func visitorConnect(sender:UIButton) -> Void {
        sender.setTitle("Loading..", for: .normal)
        view.isUserInteractionEnabled = false
        
        guard let name = nameTextField.text, let identifier = idTextField.text else { return }
        prismCore.visitorConnect(visitorName: name, userID: identifier) { [weak self] (connectResponse, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else if let response = connectResponse {
                self?.connectResponse = response
                
                self?.prismCore.createConversation(visitorName: response.visitor.name, token: response.oAuth.accessToken) { (createConversationResponse, error) in
                    
                    sender.setTitle("Connect", for: .normal)
                    self?.view.isUserInteractionEnabled = true
                    
                    if let error = error {
                        print(error)
                    } else if let response = createConversationResponse {
                        self?.createConversationResponse = response
                        
                        print("success \(response.conversation)")
                    }
                }
            }
        }
    }
    
    @IBAction func uploadPressed(sender:UIButton) -> Void {
        if let connect = connectResponse, let conversation = createConversationResponse {
            prismCore.getAttachmentURL(filename: "test-persebaya.jpg", conversationID: conversation.conversation.id, token: connect.oAuth.accessToken, completionHandler: { [weak self] (url, error) in
                let image = #imageLiteral(resourceName: "persebaya")
                guard let imageData = UIImagePNGRepresentation(image), let imageURL = url?.uploadURL else { return }
                self?.prismCore.uploadAttachment(with: imageData, url: imageURL, completionHandler: { (response, error) in
                    if let res = response {
                        print("response \(res)")
                    }
                })
            })
        }
    }
}

