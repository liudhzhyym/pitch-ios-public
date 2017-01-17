//
//  ShareViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 1/16/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import MessageUI

protocol ShareViewControllerDelegate {
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func userDidShare()
}

class ShareViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - Variables
    
    var delegate: ShareViewControllerDelegate?
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()

        updateForDarkMode()
    }
    
    func updateForDarkMode() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        if darkModeOn {
            view.backgroundColor = UIColor.darkGrayView
            for label in labels {
                label.textColor = .white
            }
            shareButton.backgroundColor = UIColor.darkInTune
        }
    }

    // MARK: - Actions

    @IBAction func shareButtonPressed(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.body = "Hey, I just downloaded this awesome tuner app called Pitch! You should check it out 👉 appstore.com/pitchtunerappforiphone"
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: { _ in
            self.delegate?.dismiss(animated: false, completion: nil)
        })
    }
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension ShareViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: { _ in
            if result == .sent {
                UserDefaults.standard.userDidShareFromAnalytics()
                self.delegate?.userDidShare()
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
}