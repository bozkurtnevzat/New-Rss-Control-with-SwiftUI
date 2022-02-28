//
//  FeedDetailModel.swift
//  Rss Feed Notifier
//
//  Created by Nevzat BOZKURT on 25.02.2022.
//

import SwiftUI

struct FeedDetailModel: Identifiable, Codable {
    var id = UUID()
    var title: String?
    var description: String?
    var url: String?
    var date: Date?
}
