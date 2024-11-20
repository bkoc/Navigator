//
//  TabView.swift
//  Nav5
//
//  Created by Michael Long on 11/15/24.
//

import SwiftUI

enum RootTabs: CaseIterable, Identifiable {
    case home
    case settings
    var id: Self { self }
}

struct RootTabView : View {
    @State var selectedTab: RootTabs = .home
    var body: some View {
        TabView(selection: $selectedTab) {
            RootHomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(RootTabs.home)
            RootSettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(RootTabs.settings)
        }
        .onNavigationReceive { (tab: RootTabs, navigator) in
            navigator.dismissAll()
            selectedTab = tab
            return .auto
        }
    }
}

#Preview {
    RootTabView()
}
