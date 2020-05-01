//
//  WelComeVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 15/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class WelComeVC: UIViewController {

   
    @IBOutlet weak var lblTermsAndPrivacy: UILabel!
    
    //MARK:- System Defined Methods............
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lblTermsAndPrivacy.isUserInteractionEnabled = true
        lblTermsAndPrivacy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:))))
    }
    
    //MARK:- UIButton Actions..............
    @IBAction func btnGetStarted(_ sender: UIButton)
    {
        isNavigationFrom = "isFromWelcomeVC"
        self.appDelegate.showtabbar()
    }
    
    @IBAction func btnLogin(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btynSignup(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleTapOnLabel(_ recognizer: UITapGestureRecognizer) {
        guard let text = lblTermsAndPrivacy.attributedText?.string else {
            return
        }

        if let range = text.range(of: NSLocalizedString("Terms of Use", comment: "Terms of Use")),
            recognizer.didTapAttributedTextInLabel(label: lblTermsAndPrivacy, inRange: NSRange(range, in: text)) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            vc.StrUrl = "terms-and-conditions"
            vc.isNavigation = "Terms & Conditions"
            self.navigationController?.pushViewController(vc, animated: true)
        } else if let range = text.range(of: NSLocalizedString("Privacy Policy", comment: "Privacy Policy")),
            recognizer.didTapAttributedTextInLabel(label: lblTermsAndPrivacy, inRange: NSRange(range, in: text)) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            vc.StrUrl = "privacy-policy"
            vc.isNavigation = "Privacy Policy"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attrString = label.attributedText else {
            return false
        }

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attrString)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
