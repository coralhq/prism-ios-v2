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
            //            DispatchQueue.main.async(){
            sender.setTitle("Connect", for: .normal)
            self?.view.isUserInteractionEnabled = true
            
            if let error = error {
                print(error.localizedDescription)
            } else if let response = connectResponse {
                self?.prismCore.createConversation(visitorName: response.visitor.name, token: "Bearer \(response.oAuth.accessToken)") { (createConversationResponse, error) in
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

