//
//  Extensions.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/5/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

extension String {
    /**
     Localisation helper
     */
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.prism, value: "", comment: "")
    }
    
    /**
     convert time string `00:00` to minutes integer
     */
    func minutes() -> Int? {
        let timeArray = self.components(separatedBy: ":")
        guard let hour = timeArray.first,
            let minute = timeArray.last,
            let intHour = Int(hour),
            let intMinute = Int(minute) else {
                return nil
        }
        return intHour * 60 + intMinute
    }
}

extension Dictionary {
    /**
     Compare two Dictionary
     */
    func isEqual(to dictionary: Dictionary?) -> Bool {
        guard let dictionary = dictionary else {
            return false
        }
        return NSDictionary(dictionary: self).isEqual(to: dictionary)
    }
}

extension NSObject {
    static func className() -> String {
        return String(describing: self)
    }
}

extension Bundle {
    static var prism: Bundle {
        return Bundle(for: ConnectViewController.classForCoder())
    }
}

extension UITableViewCell {
    static var NIB: UINib {
        return UINib.init(nibName: self.className(), bundle: Bundle.prism)
    }
}

extension Array {
    mutating func moveElement(fromIndex: Int, toIndex: Int) {
        let element = remove(at: fromIndex)
        insert(element, at: toIndex)
    }
}

extension Array where Element : ChatViewModel {
    
    func containsChatViewModel(viewModel: ChatViewModel) -> Bool {
        return self.contains(where: { (vm) -> Bool in
            return vm.messageID == viewModel.messageID
        })
    }
    
    mutating func insert(viewModel: ChatViewModel, at index: Int) {
        if self.containsChatViewModel(viewModel: viewModel) == false {
            insert(viewModel as! Element, at: index)
        }
    }
    
    mutating func update(viewModel: ChatViewModel, at index: Int) {
        remove(at: index)
        insert(viewModel as! Element, at: index)
    }
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UILabel {
    func strikeTroughLined(with text: String?) {
        if let text = text {
            let atts: [String: Any] = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                                       NSForegroundColorAttributeName: #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 0.5),
                                       NSStrikethroughStyleAttributeName: NSNumber(value: 1)]
            self.attributedText = NSAttributedString(string: text, attributes: atts)
        } else {
            self.attributedText = nil
            self.text = nil
        }
    }
}

let maxViewSize: CGFloat = 1000

extension String {
    func width(font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: maxViewSize, height: maxViewSize)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.width
    }
    
    func linesArrayString(constraint: CGSize, font: UIFont) -> [String] {
        
        let myFont = CTFontCreateWithName(font.fontName as CFString?, font.pointSize, nil)
        let attStr = NSMutableAttributedString(string: self)
        attStr.addAttribute(String(kCTFontAttributeName), value:myFont, range: NSRange(location: 0, length: attStr.length))
        let frameSetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
        let path = CGPath(rect: CGRect(x: 0, y: 0, width: constraint.width, height: constraint.height), transform: nil)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        guard let lines = CTFrameGetLines(frame) as? [CTLine] else {
            return []
        }
        
        var linesArray = [String]()
        
        for line in lines {
            let lineRange = CTLineGetStringRange(line)
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            let nsstring = self as NSString
            let lineString = nsstring.substring(with: range)
            linesArray.append(lineString as String)
        }

        return linesArray
    }
}

