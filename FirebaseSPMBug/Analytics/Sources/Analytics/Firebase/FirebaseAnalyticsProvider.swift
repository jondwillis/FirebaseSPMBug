//
//  FirebaseAnalyticsProvider.swift
//  Swiftlytics
//
//  Created by Jonathan Willis on 5/29/18.
//  Copyright © 2018 Find Your Grind. All rights reserved.
//

import FirebaseCore
import FirebaseAnalytics
import UIKit

public class FirebaseAnalyticsProvider: AnalyticsProvider {
    
    private let options: FirebaseOptions?
    
    public init(_ options: FirebaseOptions? = nil) {
        self.options = options
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        if FirebaseApp.app() == nil {
            if let options = options {
                FirebaseApp.configure(options: options)
            } else {
                FirebaseApp.configure()
            }
        }
        
        return true
    }
    
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        Analytics.handleOpen(url)
        
        return false
    }
    
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        Analytics.handleUserActivity(userActivity)

        return false
    }
    
    public func setUserId(_ id: String) {
        Analytics.setUserID(id)
    }
    
    public func resetUser() {
        Analytics.setUserID(nil)
        Analytics.resetAnalyticsData()
    }

    public func setUserProperty(name propertyName: String, withValue value: Any) {
        let fixedName = propertyName
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "$", with: "")
        if let value = value as? String {
            Analytics.setUserProperty(value, forName: fixedName)
        } else if let value = value as? CustomStringConvertible {
            Analytics.setUserProperty(value.description, forName: fixedName)
        }
    }
    
    public func trackEvent(_ event: AnalyticsEventConvertible) {
        Analytics.logEvent(event.name, parameters: try! event.properties()) // swiftlint:disable:this force_cast
    }
    
    public func trackScreen(name: String) {
        Analytics.logEvent(
            AnalyticsEventScreenView,
            parameters: [
                AnalyticsParameterScreenName: name,
                AnalyticsParameterScreenClass: name,
            ]
        )
    }
    
    public func trackError(_ error: Error) {
        // no-op
    }
    
    public func trackError(_ error: NSError) {
        // no-op
    }
}
