//
//  SafariWebExtensionHandler.swift
//  Shared (Extension)
//
//  Created by Rafan Syed on 4/2/26.
//

import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    let appGroup = "group.com.rafan.YTBlocker"

    func beginRequest(with context: NSExtensionContext) {
        let request = context.inputItems.first as? NSExtensionItem

        let profile: UUID?
        if #available(iOS 17.0, macOS 14.0, *) {
            profile = request?.userInfo?[SFExtensionProfileKey] as? UUID
        } else {
            profile = request?.userInfo?["profile"] as? UUID
        }

        let message: Any?
        if #available(iOS 15.0, macOS 11.0, *) {
            message = request?.userInfo?[SFExtensionMessageKey]
        } else {
            message = request?.userInfo?["message"]
        }

        os_log(.default, "Received message from browser.runtime.sendNativeMessage: %@ (profile: %@)", String(describing: message), profile?.uuidString ?? "none")

        // Handle settings fetch request from background.js
        if let dict = message as? [String: Any],
           let action = dict["action"] as? String,
           action == "get-settings" {

            let shared = UserDefaults(suiteName: appGroup)
            let settings: [String: Any] = shared?.dictionary(forKey: "ytbSettings") ?? [
                "blockShorts":   false,
                "blockSearch":   false,
                "blockComments": false
            ]

            let response = NSExtensionItem()
            if #available(iOS 15.0, macOS 11.0, *) {
                response.userInfo = [SFExtensionMessageKey: settings]
            } else {
                response.userInfo = ["message": settings]
            }
            context.completeRequest(returningItems: [response], completionHandler: nil)
            return
        }

        // Default: echo back
        let response = NSExtensionItem()
        if #available(iOS 15.0, macOS 11.0, *) {
            response.userInfo = [SFExtensionMessageKey: ["echo": message as Any]]
        } else {
            response.userInfo = ["message": ["echo": message as Any]]
        }
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
}
