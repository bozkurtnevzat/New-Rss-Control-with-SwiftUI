//
//  FeedListItem.swift
//  Rss Feed Notifier
//
//  Created by Nevzat BOZKURT on 25.02.2022.
//

import SwiftUI

struct FeedListItem: View {
    var title: String = "Feed Title"
    var url: String = "Feed URL"
    var description: String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title).font(.title3).bold().lineLimit(1)
            if description != "" {
                Text(description).font(.callout).foregroundColor(.secondary).lineLimit(2)
            }
            if url != "" {
                Text(url).font(.callout).foregroundColor(.secondary).lineLimit(1)
            }
            
        }
    }
}
