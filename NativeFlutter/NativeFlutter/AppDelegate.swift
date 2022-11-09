//
//  AppDelegate.swift
//  NativeFlutter
//
//  Created by pc on 2022/11/7.
//

import UIKit
import Flutter
import FlutterPluginRegistrant

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let flutterEngine = FlutterEngine(name: "flutter engine")

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GeneratedPluginRegistrant.register(with: flutterEngine)
        var run = flutterEngine.run()
        print("AppDelegate run: \(run)")

        return true
    }

}

