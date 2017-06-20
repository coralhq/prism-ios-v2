//
//  ChatInvoiceView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

enum InvoicePaymentType {
    case Midtrans
    case COD
    case BankTransfer
}

class ChatInvoiceView: UIView {
    let midtransView = MidtransView.viewFromNib() as! MidtransView
    @IBOutlet var containerView: UIStackView!
    
    var invoiceType: InvoicePaymentType = .COD {
        didSet {
            midtransView.removeFromSuperview()
            
            switch invoiceType {
            case .Midtrans:
                containerView.addArrangedSubview(midtransView)
                break
            default:
                break
            }
        }
    }
}

extension ChatInvoiceView: ChatContentProtocol {
    func addTo(view: UIView?) {
        addTo(view: view, margin: 0)
    }
    
    func infoPosition() -> InfoViewPosition {
        return .Bottom
    }
}
