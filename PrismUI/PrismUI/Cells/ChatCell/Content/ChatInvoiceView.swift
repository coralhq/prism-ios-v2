//
//  ChatInvoiceView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class ChatInvoiceProductView: UIView {
    let nameLabel: UILabel
    let priceLabel: UILabel
    let optionLabel: UILabel
    let notesLabel: UILabel
    
    init(viewModel: ContentInvoiceProductViewModel) {
        nameLabel = UILabel()
        priceLabel = UILabel()
        optionLabel = UILabel()
        notesLabel = UILabel()
        
        super.init(frame: .zero)
        
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = UIColor.jetBlack
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        optionLabel.font = UIFont.italicSystemFont(ofSize: 14)
        optionLabel.textColor = UIColor.jetBlack
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(optionLabel)
        
        notesLabel.font = UIFont.systemFont(ofSize: 14)
        notesLabel.textColor = UIColor.jetBlack
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(notesLabel)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(priceLabel)
        
        let views: [String: Any] = ["price": priceLabel,
                                    "name": nameLabel,
                                    "options": optionLabel,
                                    "notes": notesLabel]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[price]-0-|", options: .init(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[options]-0-|", options: .init(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[notes]-0-|", options: .init(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[name]-0-|", options: .init(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[name]-0-[options]-0-[price]-0-[notes]-0-|", options: .init(rawValue: 0), metrics: nil, views: views))
        
        nameLabel.text = viewModel.name
        priceLabel.attributedText = viewModel.price
        optionLabel.text = viewModel.options
        notesLabel.text = viewModel.notes
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatInvoiceView: ChatContentView {
    let paymentLinkView: PaymentLinkView = PaymentLinkView.viewFromNib()!
    
    @IBOutlet var containerView: UIStackView!
    @IBOutlet var productContainerView: UIStackView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var shipCostLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var paymentMethodLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var notesLabel: UILabel!
    
    var payment: PaymentProviderViewModel? {
        didSet {
            guard let payment = payment else {
                return
            }
            
            if payment.type == "transfer" {
                let info = payment.bankInfo!
                let paymentMethod = "Payment Method".localized() + " = " + payment.name
                let accountNumber = "Account Number".localized() + " = " + info.accountNumber
                let accountHolder = "Account Holder".localized() + " = " + info.accountHolder
                let bankName = "Bank Name".localized() + " = " + info.bankName
                paymentMethodLabel.text = "\(paymentMethod) \n\(accountNumber) \n\(accountHolder) \n\(bankName)"
            } else {
                paymentMethodLabel.text = "Payment Method".localized() + " = " + payment.name
            }
            
            if let _ = payment.url {
                containerView.addArrangedSubview(paymentLinkView)
                calculateContentWidth(label: paymentLinkView.descLabel, supportLeft: false)
            } else {
                paymentLinkView.removeFromSuperview()
                calculateContentWidth(label: paymentMethodLabel, supportLeft: false)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        paymentLinkView.payButton.addTarget(self, action: #selector(payPressed(sender:)), for: .touchUpInside)
    }
    
    func payPressed(sender: UIButton) {
        guard let payURL = payment?.url,
            UIApplication.shared.canOpenURL(payURL) else { return }
        UIApplication.shared.openURL(payURL)
    }
    
    override func updateView(with viewModel: ChatViewModel) {
        guard let contentVM = viewModel.contentViewModel as? ContentInvoiceViewModel else {
            return
        }
        nameLabel.text = contentVM.name
        phoneLabel.text = contentVM.phoneNumber
        emailLabel.text = contentVM.email
        addressLabel.text = contentVM.address
        shipCostLabel.text = contentVM.shippingCost
        totalPriceLabel.text = contentVM.totalPrice        
        dateLabel.text = contentVM.invoiceTime
        notesLabel.text = contentVM.notes
        
        payment = contentVM.payment
        
        for view in productContainerView.arrangedSubviews {
            productContainerView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for itemVM in contentVM.productModels {
            productContainerView.addArrangedSubview(ChatInvoiceProductView(viewModel: itemVM))
        }
    }
}
