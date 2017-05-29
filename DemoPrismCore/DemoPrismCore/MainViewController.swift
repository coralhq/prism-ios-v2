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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PrismCore.shared.configure(environment: EnvironmentType.Sandbox, merchantID: "62ccf49f-0386-49a3-858c-70c98a9dc4fc", delegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func visitorConnect(_ sender: UIButton) {
        sender.setTitle("Loading..", for: .normal)
        view.isUserInteractionEnabled = false
        
        guard let name = nameTextField.text, let identifier = idTextField.text else { return }
        PrismCore.shared.visitorConnect(visitorName: name, userID: identifier) { [weak self] (connectResponse, error) in
            //            DispatchQueue.main.async(){
            sender.setTitle("Connect", for: .normal)
            self?.view.isUserInteractionEnabled = true
            
            if let error = error {
                print(error.localizedDescription)
            } else if let response = connectResponse {
                PrismCore.shared.createConversation(visitorName: response.visitor.name, token: "Bearer \(response.oAuth.accessToken)") { (createConversationResponse, error) in
                    if let error = error {
                        print(error)
                    } else if let response = createConversationResponse {
                        print("success \(response.conversation)")
                    }
                }
            }
            //            }
        }
    }
}

extension MainViewController: PrismCoreDelegate {
    
    func didReceive(message data: Data, in topic: String) {
        
    }
}
