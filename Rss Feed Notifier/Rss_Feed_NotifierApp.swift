//
//  Rss_Feed_NotifierApp.swift
//  Rss Feed Notifier
//
//  Created by Nevzat BOZKURT on 22.02.2022.
//

import SwiftUI

@main
struct Rss_Feed_NotifierApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NewFeedsView().tabItem {
                    VStack {
                        Image(systemName: "n.square")
                        Text("New Feeds")
                    }
                }.tag(1)
                FeedListView().tabItem {
                    VStack{
                        Image(systemName: "dot.radiowaves.up.forward")
                        Text("My Feeds")
                    }
                }.tag(2)
            }
        }
    }
}
