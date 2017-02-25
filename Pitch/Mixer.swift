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
    
    static let sharedInstance: Mixer = Mixer()
    private var mixer: AKMixer!
    var isSetup: Bool = false
    
    private override init() {}
    
    func setUp() {
        self.mixer = AKMixer(Tuner.sharedInstance.silence)
        mixer.connect(SoundGenerator.sharedInstance.bank)
        
        AudioKit.output = mixer
        try! AKSettings.session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        if !AudioKit.audioInUseByOtherApps() {
            AudioKit.start()
            isSetup = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChanged(_:)), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
    }
    
    func audioRouteChanged(_ notification: Notification) {
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        print(audioRouteChangeReason)
        
        switch audioRouteChangeReason {
        case AVAudioSessionRouteChangeReason.newDeviceAvailable.rawValue:
            return
        case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.rawValue:
            return
        default:
            if !isSetup {
                self.setUp()
            }
        }
    }
}