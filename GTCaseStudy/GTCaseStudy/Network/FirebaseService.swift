//
//  FirebaseService.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 10.05.2025.
//

import Foundation
import FirebaseAnalytics
import FirebaseCrashlytics
import FirebaseRemoteConfig
import FirebaseMessaging

protocol IFirebaseService {
    func logEvent(_ name: String, parameters: [String: Any]?)
    func setUserId(_ userId: String?)
    func setUserProperty(_ value: String?, forName name: String)
    func logError(_ error: Error, userInfo: [String: Any]?)
    func fetchRemoteConfig(completion: @escaping (Bool) -> Void)
    func getRemoteConfigValue(forKey key: String) -> String?
}

final class FirebaseService: NSObject, IFirebaseService, MessagingDelegate {
    static let shared = FirebaseService()
    private let remoteConfig = RemoteConfig.remoteConfig()

    private override init() {
        super.init()
        Messaging.messaging().delegate = self
    }

    // Analytics
    func logEvent(_ name: String, parameters: [String: Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
    func setUserId(_ userId: String?) {
        Analytics.setUserID(userId)
    }
    func setUserProperty(_ value: String?, forName name: String) {
        Analytics.setUserProperty(value, forName: name)
    }

    // Crashlytics
    func logError(_ error: Error, userInfo: [String: Any]?) {
        Crashlytics.crashlytics().record(error: error)
        userInfo?.forEach { key, value in
            Crashlytics.crashlytics().setCustomValue(value, forKey: key)
        }
    }

    // Remote Config
    func fetchRemoteConfig(completion: @escaping (Bool) -> Void) {
        remoteConfig.fetchAndActivate { status, error in
            completion(error == nil)
        }
    }
    func getRemoteConfigValue(forKey key: String) -> String? {
        remoteConfig.configValue(forKey: key).stringValue
    }

    // MessagingDelegate (Push)
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token: \(fcmToken ?? "")")
    }
} 
