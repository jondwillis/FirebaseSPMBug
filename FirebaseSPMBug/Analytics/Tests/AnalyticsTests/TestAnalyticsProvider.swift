//
//  File.swift
//  
//
//  Created by Jonathan Willis on 10/14/20.
//

import UIKit
import Analytics

class TestAnalyticsProvider: AnalyticsProvider {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
    ) -> Bool {
        return true
    }

    func application(
        _ application: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any]
    ) -> Bool {
        return true
    }

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        return true
    }

    var didSetUserId = false
    func setUserId(_ id: String) {
        didSetUserId = true
    }
    
    var didSetUserProperty = false
    func setUserProperty(name propertyName: String, withValue value: Any) {
        didSetUserProperty = true
    }
    
    var didResetUser = false
    func resetUser() {
        didResetUser = true
    }
    
    var didTrackScreen = false
    func trackScreen(name: String) {
        didTrackScreen = true
    }
    
    var didTrackEvent = false
    func trackEvent(_ event: AnalyticsEventConvertible) {
        didTrackEvent = false
    }
    
    var didTrackError = false
    func trackError(_ error: Error) {
        didTrackError = true
    }
    
    var didTrackNSError = false
    func trackError(_ error: NSError) {
        didTrackNSError = true
    }
}
