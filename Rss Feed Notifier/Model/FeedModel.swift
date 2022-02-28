//
//  FeedModel.swift
//  Rss Feed Notifier
//
//  Created by Nevzat BOZKURT on 23.02.2022.
//

import SwiftUI

struct FeedModel: Identifiable, Codable {
    var id = UUID()
    var title: String
    var url: String
    var lastSeen: Date
}
