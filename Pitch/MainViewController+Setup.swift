//
//  MainViewController+Setup.swift
//  Pitch
//
//  Created by Daniel Kuntz on 1/20/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import AudioKit

extension MainViewController {
    
    // MARK: - Setup 
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(openToneGenerator), name: .openToneGenerator, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openAnalytics), name: .openAnalytics, object: nil)
    }
    
    func checkRecordPermission() {
        let recordPermissionGranted = UserDefaults.standard.recordPermission()
        if recordPermissionGranted {
            setupTuner()
        } else {
            requestRecordPermission()
        }
    }
    
    func requestRecordPermission() {
        AKSettings.session.requestRecordPermission() { (granted: Bool) -> Void in
            if granted {
                DispatchQueue.main.async {
                    UserDefaults.standard.setRecordPermission(granted)
                    self.setupTuner()
                }
            }
        }
    }
    
    func setupTuner() {
        tunerSetup = true
        tuner = Tuner()
        tuner?.delegate = self
        pitchPipeView.soundGenerator.tuner = self.tuner
        pitchPipeView.soundGenerator.setUp()
        tuner?.start()
    }
    
    func setupUI() {
        self.pitchPipeBottomConstraint.constant = -231
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        
        setupAnalyticsCircle()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.darkModeChanged), name: .darkModeChanged, object: nil)
        darkModeChanged()
    }
    
    func setupAnalyticsCircle() {
        analyticsCircle.colorful = false
        analyticsCircle.circleLayer.lineWidth = 1.0
        analyticsCircle.removeBorder()
        
        if today.hasSufficientData {
            shouldUpdateAnalyticsCircle = false
        }
    }
    
    func setupPlot() {
        plot = AKNodeOutputPlot((tuner?.microphone)!, frame: audioPlot.bounds)
        plot.plotType = .rolling
        plot.shouldFill = false
        plot.shouldMirror = true
        plot.color = UIColor.white
        plot.gain = 3.0
        plot.backgroundColor = UIColor.clear
        audioPlot.addSubview(plot)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(plotTapped))
        audioPlot.addGestureRecognizer(tapGR)
    }
}
