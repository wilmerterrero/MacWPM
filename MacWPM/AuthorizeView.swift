//
//  AuthorizeView.swift
//  MacWPM
//
//  Created by Wilmer Terrero on 19/5/24.
//

import SwiftUI

struct AuthorizeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("MacWPMIcon")
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.top, 40)
            
            Text("Authorize MacWPM")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 8) {
                Text("MacWPM needs your permission to emulate keystrocks to record your WPM.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                Text("Follow these steps to authorize it:")
                    .font(.body)
                    .multilineTextAlignment(.center)
                
            }
            .padding(.horizontal, 40)
            
            
            VStack(alignment: .leading, spacing: 10) {
                Button(action: {
                    openSystemSettings()
                }) {
                    HStack {
                        Image(systemName: "gear")
                        Text("Open System Settings")
                    }
                    .font(.system(size: 16, weight: .semibold))
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    openPrivacySettings()
                }) {
                    HStack {
                        Image(systemName: "hand.raised.fill")
                        Text("Privacy & Security")
                    }
                    .font(.system(size: 16, weight: .semibold))
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    openAccessibilitySettings()
                }) {
                    HStack {
                        Image(systemName: "figure.stand")
                        Text("Accessibility")
                    }
                    .font(.system(size: 16, weight: .semibold))
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    // Assuming this is a function to guide the user to enable the app
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Enable MacWPM.app")
                    }
                    .font(.system(size: 16, weight: .semibold))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
    
    func openSystemSettings() {
        let url = URL(string: "x-apple.systempreferences:")!
        NSWorkspace.shared.open(url)
    }
    
    func openPrivacySettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy")!
        NSWorkspace.shared.open(url)
    }
    
    func openAccessibilitySettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.universalaccess")!
        NSWorkspace.shared.open(url)
    }
}

#Preview {
    AuthorizeView()
}
