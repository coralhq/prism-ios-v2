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
    
    init(viewModel: ContentInvoiceProductViewModel) {
        nameLabel = UILabel()
        priceLabel = UILabel()
        
        super.init(frame: .zero)
        
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = UIColor.jetBlack
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(priceLabel)
        
        let views: [String: Any] = ["price": priceLabel,
                                    "name": nameLabel]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[price]-0-|", options: .init(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[name]-0-|", options: .init(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[name]-0-[price]-0-|", options: .init(rawValue: 0), metrics: nil, views: views))
        
        nameLabel.text = viewModel.name
        priceLabel.attributedText = viewModel.price
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatInvoiceView: ChatContentView {
    let midtransView: MidtransView = MidtransView.viewFromNib()!
    
    @IBOutlet var containerView: UIStackView!
    @IBOutlet var productContainerView: UIStackView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var shipCostLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var paymentMethodLabel: UILabel!
    
    var midtransPaymentURL: URL?
    
    var paymentMethod: PaymentMethod? {
        didSet {
            guard let pm = paymentMethod else { return }
            midtransView.removeFromSuperview()
            switch pm {
            case .midtrans:
                containerView.addArrangedSubview(midtransView)
            default:
                break
            }
            paymentMethodLabel.text = "Payment Method".localized() + " = " + pm.name()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        midtransView.payButton.addTarget(self, action: #selector(midtransPayPressed(sender:)), for: .touchUpInside)
    }
    
    func midtransPayPressed(sender: UIButton) {
        guard let payURL = midtransPaymentURL,
            UIApplication.shared.canOpenURL(payURL) else { return }
        UIApplication.shared.openURL(payURL)
    }
    
    override func infoPosition() -> InfoViewPosition {
        return .Bottom
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
        
        paymentMethod = contentVM.paymentMethod
        midtransPaymentURL = contentVM.midtransPaymentURL
        
        for view in productContainerView.arrangedSubviews {
            productContainerView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for itemVM in contentVM.productModels {
            productContainerView.addArrangedSubview(ChatInvoiceProductView(viewModel: itemVM))
        }
    }
}
