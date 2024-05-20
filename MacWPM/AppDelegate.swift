//
//  AppDelegate.swift
//  MacWPM
//
//  Created by Wilmer Terrero on 19/5/24.
//

import SwiftUI
import Sparkle

class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var instance: AppDelegate!
    
    var statusItem: NSStatusItem!
    var keyDownEventMonitor: Any?
    var keyUpEventMonitor: Any?
    
    private var startTime: Date?
    private var resetTimer: Timer?
    private var keystrokeCount = 0
    private var totalKeystrokes = 0
    private var totalTime: TimeInterval = 0
    private var isSessionStarted = false
    
    let updaterController: SPUStandardUpdaterController
    
    override init() {
        // Sparkle auto-updater config
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.instance = self
        // Request Accessibility Permissions
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        if !accessEnabled {
            openNewWindow(view: AuthorizeView())
            return
        }
        
        // Set up status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "WPM: 0.00"
        
        // Create the menu
        let menu = NSMenu()
        
        // Create the images
        let startImage = NSImage(systemSymbolName: "play.fill", accessibilityDescription: "Start")
        let resetImage = NSImage(systemSymbolName: "arrow.counterclockwise", accessibilityDescription: "Reset")
        let endImage = NSImage(systemSymbolName: "stop.fill", accessibilityDescription: "End")
        
        // Add the "Start Session" menu item
        let startMenuItem = NSMenuItem(title: "Start Session", action: #selector(startSession), keyEquivalent: "")
        startMenuItem.image = startImage
        menu.addItem(startMenuItem)
        
        // Add the "Reset Session" menu item
        let resetMenuItem = NSMenuItem(title: "Reset Session", action: #selector(resetSession), keyEquivalent: "")
        resetMenuItem.image = resetImage
        menu.addItem(resetMenuItem)
        
        // Add the "End Session" menu item
        let endMenuItem = NSMenuItem(title: "End Session", action: #selector(endSession), keyEquivalent: "")
        endMenuItem.image = endImage
        menu.addItem(endMenuItem)
        
        // Extras menu item's
        menu.addItem(.separator())
        
        // Check for Updates menu item
        let checkForUpdatesMenuItem = NSMenuItem()
        checkForUpdatesMenuItem.title = "Check for Updates…"
        checkForUpdatesMenuItem.target = updaterController
        checkForUpdatesMenuItem.action = #selector(SPUStandardUpdaterController.checkForUpdates(_:))
        menu.addItem(checkForUpdatesMenuItem)

        menu.addItem(.separator())

        menu.addItem(withTitle: "Quit",
                     action: #selector(quit),
                     keyEquivalent: "q")
        
        // Set the menu for the status bar item
        statusItem.menu = menu
        
        // Set up global event monitors
        keyDownEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyEvent(event)
        }
        
        keyUpEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyUp) { [weak self] event in
            self?.handleKeyEvent(event)
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        if let keyDownEventMonitor = keyDownEventMonitor {
            NSEvent.removeMonitor(keyDownEventMonitor)
        }
        if let keyUpEventMonitor = keyUpEventMonitor {
            NSEvent.removeMonitor(keyUpEventMonitor)
        }
    }
    
    private func handleKeyEvent(_ event: NSEvent) {
        if !isSessionStarted {
            return
        }
        
        resetTimer?.invalidate()
        resetTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(endSession), userInfo: nil, repeats: false)
        
        if startTime == nil {
            startTime = Date()
        }
        
        // Exclude modifier keys and delete/backspace keys
        let excludedKeys: [UInt16] = [51, 52, 117] // Key codes for delete and backspace
        let modifierFlags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        if !excludedKeys.contains(event.keyCode) && modifierFlags.isEmpty {
            keystrokeCount += 1
        }
        
        updateWPM()
    }
    
    private func updateWPM() {
        guard let startTime = startTime else { return }
        
        let timeInterval = Date().timeIntervalSince(startTime)
        let minutes = timeInterval / 60.0
        let wpm = Double(keystrokeCount / 5) / minutes
        let overalWPM = wpm / 10
        
        statusItem.button?.title = String(format: "WPM: %.2f", overalWPM)
    }
    
    @objc func startSession(_ sender: Any) {
        // Start the session
        isSessionStarted = true
        startTime = Date()
        keystrokeCount = 0
        statusItem.button?.title = "WPM: 0.00"
    }
    
    @objc func resetSession(_ sender: Any) {
        invalidateTimer()
        
        // Reset session
        startTime = nil
        isSessionStarted = false
        keystrokeCount = 0
        statusItem.button?.title = "WPM: 0.00"
    }
    
    @objc func endSession(_ sender: Any) {
        invalidateTimer()
        
        guard let _startTime = startTime else { return }
        
        let timeInterval = Date().timeIntervalSince(_startTime)
        totalKeystrokes += keystrokeCount
        totalTime += timeInterval
        
        // Reset session
        startTime = nil
        keystrokeCount = 0
        isSessionStarted = false
    }
    
    @objc private func quit(sender: NSMenuItem) {
        NSApp.terminate(self)
    }
    
    private func invalidateTimer() {
        resetTimer?.invalidate()
        resetTimer = nil
    }
}
