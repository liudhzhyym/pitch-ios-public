//
//  Mixer.swift
//  Pitch
//
//  Created by Daniel Kuntz on 2/20/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import AudioKit

class Mixer: NSObject {
    
    // MARK: - Properties
    
    static let shared: Mixer = Mixer()
    
    fileprivate var mixer: AKMixer!
    var tuner: Tuner = Tuner()
    var soundGenerator: SoundGenerator = SoundGenerator()
    var recorder: Recorder = Recorder()
    
    var isSetup: Bool = false
    
    // MARK: - Setup
    
    fileprivate override init() {}
    
    func setUp() {
        self.mixer = AKMixer(tuner.silence, soundGenerator.bank)
        AudioKit.output = mixer
        
        if !AudioKit.audioInUseByOtherApps() {
            AudioKit.start()
            isSetup = true
        }
        
        try! AKSettings.setSession(category: .playAndRecord, with: .defaultToSpeaker)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChanged(_:)), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
    }
    
    func audioRouteChanged(_ notification: Notification) {
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        
        switch audioRouteChangeReason {
        case AVAudioSessionRouteChangeReason.newDeviceAvailable.rawValue:
            return
        case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.rawValue:
            return
        default:
            if !isSetup {
//                self.setUp()
            }
        }
    }
}
