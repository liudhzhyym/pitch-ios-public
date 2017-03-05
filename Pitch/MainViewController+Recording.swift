//
//  MainViewController+Recording.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/3/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

extension MainViewController: SessionsViewControllerDelegate {
    
    // MARK: - Recording
    
    func prepareForRecording() {
        recordViewTopConstraint.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.tunerView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func startRecording() {
        recordingState = .recording
        leftRecordButton.setTitle("Stop", for: .normal)
        
        leftRecordButtonConstraint.constant = 15
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.recordView.layoutIfNeeded()
            self.rightRecordButton.alpha = 0.0
        }, completion: nil)
        
        Recorder.sharedInstance.startRecording()
    }
    
    func stopRecording() {
        recordingState = .doneRecording
        leftRecordButton.setTitle("Save", for: .normal)
        rightRecordButton.setTitle("Discard", for: .normal)
        
        leftRecordButtonConstraint.constant = 100
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.recordView.layoutIfNeeded()
            self.rightRecordButton.alpha = 1.0
        }, completion: nil)
        
        Recorder.sharedInstance.stopRecording()
    }
    
    func saveRecording() {
        recordingState = .notRecording
        resetRecordView()
        
        Recorder.sharedInstance.reset()
    }
    
    func cancelRecording() {
        recordingState = .notRecording
        resetRecordView()
        
        Recorder.sharedInstance.deleteCurrentRecording()
        Recorder.sharedInstance.reset()
    }
    
    func resetRecordView() {
        recordLabel.text = "Ready to record"
        leftRecordButton.setTitle("Start", for: .normal)
        rightRecordButton.setTitle("Cancel", for: .normal)
        
        recordViewTopConstraint.constant = -recordView.frame.height
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.tunerView.layoutIfNeeded()
        }, completion: nil)
    }
}

enum MainViewRecordingState {
    case notRecording
    case ready
    case recording
    case doneRecording
}