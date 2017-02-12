//
//  Preferences.swift
//  Bluefruit Connect
//
//  Created by Antonio García on 29/09/15.
//  Copyright © 2015 Adafruit. All rights reserved.
//

import Foundation

#if os(OSX)
    import AppKit
#else       // iOS, tvOS
    import UIKit
#endif

@objc class Preferences: NSObject {                // will be used from objective-c so make it inherit from NSObject
    
    // Note: if these contanst change, update DefaultPreferences.plist
    private static let appInSystemStatusBarKey = "AppInSystemStatusBar"
    
    private static let scanFilterIsPanelOpenKey = "ScanFilterIsPanelOpen"
    private static let scanFilterNameKey = "ScanFilterName"
    private static let scanFilterIsNameExactKey = "ScanFilterIsNameExact"
    private static let scanFilterIsNameCaseInsensitiveKey = "ScanFilterIsNameCaseInsensitive"
    private static let scanFilterRssiValueKey = "ScanFilterRssiValue"
    private static let scanFilterIsUnnamedEnabledKey = "ScanFilterIsUnnamedEnabled"
    private static let scanFilterIsOnlyWithUartEnabledKey = "ScanFilterIsOnlyWithUartEnabled"
    
    private static let updateServerUrlKey = "UpdateServerUrl"
    private static let updateShowBetaVersionsKey = "UpdateShowBetaVersions"
    private static let updateIgnoredVersionKey = "UpdateIgnoredVersion"

    private static let infoRefreshOnLoadKey = "InfoRefreshOnLoad"

    private static let uartReceivedDataColorKey = "UartReceivedDataColor"
    private static let uartSentDataColorKey = "UartSentDataColor"
    private static let uartIsDisplayModeTimestampKey = "UartIsDisplayModeTimestamp"
    private static let uartIsInHexModeKey = "UartIsInHexMode"
    private static let uartIsEchoEnabledKey = "UartIsEchoEnabled"
    private static let uartIsAutomaticEolEnabledKey = "UartIsAutomaticEolEnabled"
    private static let uartShowInvisibleCharsKey = "UartShowInvisibleChars"
    
    private static let neopixelIsSketchTooltipEnabledKey = "NeopixelIsSketchTooltipEnabledKey"
    
    enum PreferencesNotifications: String {
        case DidUpdatePreferences = "didUpdatePreferences"          // Note: used on some objective-c code, so when changed, update it
    }
    
    // MARK: - General
    static var appInSystemStatusBar: Bool {
        get {
            return getBoolPreference(Preferences.appInSystemStatusBarKey)
        }
        set {
            setBoolPreference(Preferences.appInSystemStatusBarKey, newValue: newValue)
        }
    }
    
    // MARK: - Scanning Filters
    static var scanFilterIsPanelOpen: Bool {
        get {
            return getBoolPreference(Preferences.scanFilterIsPanelOpenKey)
        }
        set {
            setBoolPreference(Preferences.scanFilterIsPanelOpenKey, newValue: newValue)
        }
    }

    static var scanFilterName: String? {
        get {
            let defaults = UserDefaults.standard
            return defaults.string(forKey: Preferences.scanFilterNameKey)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: Preferences.scanFilterNameKey)
        }
    }
    
    static var scanFilterIsNameExact: Bool {
        get {
            return getBoolPreference(Preferences.scanFilterIsNameExactKey)
        }
        set {
            setBoolPreference(Preferences.scanFilterIsNameExactKey, newValue: newValue)
        }
    }

    static var scanFilterIsNameCaseInsensitive: Bool {
        get {
            return getBoolPreference(Preferences.scanFilterIsNameCaseInsensitiveKey)
        }
        set {
            setBoolPreference(Preferences.scanFilterIsNameCaseInsensitiveKey, newValue: newValue)
        }
    }

    static var scanFilterRssiValue: Int? {
        get {
            let defaults = UserDefaults.standard
            let rssiValue = defaults.integer(forKey: Preferences.scanFilterRssiValueKey)
            return rssiValue >= 0 ? rssiValue:nil
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue ?? -1, forKey: Preferences.scanFilterRssiValueKey)
        }
    }
    
    static var scanFilterIsUnnamedEnabled: Bool {
        get {
            return getBoolPreference(Preferences.scanFilterIsUnnamedEnabledKey)
        }
        set {
            setBoolPreference(Preferences.scanFilterIsUnnamedEnabledKey, newValue: newValue)
        }
    }
    
    static var scanFilterIsOnlyWithUartEnabled: Bool {
        get {
            return getBoolPreference(Preferences.scanFilterIsOnlyWithUartEnabledKey)
        }
        set {
            setBoolPreference(Preferences.scanFilterIsOnlyWithUartEnabledKey, newValue: newValue)
        }
    }
    
    // MARK: - Firmware Updates
    static var updateServerUrl: NSURL? {
        get {
            let defaults = UserDefaults.standard
            let urlString = defaults.string(forKey: Preferences.updateServerUrlKey)
            if let urlString = urlString {
                return NSURL(string: urlString)
            }
            else {
                return nil
            }
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue?.absoluteString, forKey: Preferences.updateServerUrlKey)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PreferencesNotifications.DidUpdatePreferences.rawValue), object: nil)
        }
    }
    
    static var showBetaVersions: Bool {
        get {
            return getBoolPreference(Preferences.updateShowBetaVersionsKey)
        }
        set {
            setBoolPreference(Preferences.updateShowBetaVersionsKey, newValue: newValue)
        }
    }
    
    static var softwareUpdateIgnoredVersion: String? {
        get {
            let defaults = UserDefaults.standard
            return defaults.string(forKey: Preferences.updateIgnoredVersionKey)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: Preferences.updateIgnoredVersionKey)
        }
    }
    
    // MARK: - Info
    static var infoIsRefreshOnLoadEnabled: Bool {
        get {
            return getBoolPreference(Preferences.infoRefreshOnLoadKey)
        }
        set {
            setBoolPreference(Preferences.infoRefreshOnLoadKey, newValue: newValue)
        }
    }
    
    
    // MARK: - Uart
    
    static var uartShowInvisibleChars: Bool {
        get {
            return getBoolPreference(Preferences.uartShowInvisibleCharsKey)
        }
        set {
            setBoolPreference(Preferences.uartShowInvisibleCharsKey, newValue: newValue)
        }
    }
    
    
    static var uartIsDisplayModeTimestamp: Bool {
        get {
            return getBoolPreference(Preferences.uartIsDisplayModeTimestampKey)
        }
        set {
            setBoolPreference(Preferences.uartIsDisplayModeTimestampKey, newValue: newValue)
        }
    }
    
    static var uartIsInHexMode: Bool {
        get {
            return getBoolPreference(Preferences.uartIsInHexModeKey)
        }
        set {
            setBoolPreference(Preferences.uartIsInHexModeKey, newValue: newValue)
        }
    }
    
    static var uartIsEchoEnabled: Bool {
        get {
            return getBoolPreference(Preferences.uartIsEchoEnabledKey)
        }
        set {
            setBoolPreference(Preferences.uartIsEchoEnabledKey, newValue: newValue)
        }
    }
    
    static var uartIsAutomaticEolEnabled: Bool {
        get {
            return getBoolPreference(Preferences.uartIsAutomaticEolEnabledKey)
        }
        set {
            setBoolPreference(Preferences.uartIsAutomaticEolEnabledKey, newValue: newValue)
        }
    }
    
    // MARK: - Neopixels
    static var neopixelIsSketchTooltipEnabled: Bool {
        get {
            return getBoolPreference(Preferences.neopixelIsSketchTooltipEnabledKey)
        }
        set {
            setBoolPreference(Preferences.neopixelIsSketchTooltipEnabledKey, newValue: newValue)
        }
    }
    
    // MARK: - Common
    static func getBoolPreference(_ key: String) -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: key)
    }
    
    static func setBoolPreference(_ key: String, newValue: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(newValue, forKey: key)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PreferencesNotifications.DidUpdatePreferences.rawValue), object: nil)
    }
    
    // MARK: - Defaults
    static func registerDefaults() {
        let path = Bundle.main.path(forResource: "DefaultPreferences", ofType: "plist")!
        let defaultPrefs = NSDictionary(contentsOfFile: path) as! [String : AnyObject]
        
        UserDefaults.standard.register(defaults: defaultPrefs)
    }
    
    static func resetDefaults() {
        let appDomain = Bundle.main.bundleIdentifier!
        let defaults = UserDefaults.standard
        defaults.removePersistentDomain(forName: appDomain)
    }
}

