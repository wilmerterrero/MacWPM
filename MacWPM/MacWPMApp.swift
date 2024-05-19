//
//  MacWPMApp.swift
//  MacWPM
//
//  Created by Wilmer Terrero on 19/5/24.
//

import SwiftUI

@main
struct MacWPMApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

func openNewWindow(view: some View) {
    let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 600, height: 600),
                          styleMask: [.closable, .titled],
                         backing: .buffered,
                         defer: false)
                    
    window.center()
    window.contentView = NSHostingView(rootView: view)
    window.isReleasedWhenClosed = false
    window.makeKeyAndOrderFront(nil)
    window.orderFrontRegardless()
}
