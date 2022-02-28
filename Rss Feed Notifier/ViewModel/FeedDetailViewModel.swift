//
//  FeedDetailViewModel.swift
//  Rss Feed Notifier
//
//  Created by Nevzat BOZKURT on 25.02.2022.
//

import SwiftUI
import FeedKit

class FeedDetailViewModel: ObservableObject {
    @Published var data: [FeedDetailModel] = []
    var isLoading: Bool = false
    
    func getData(url: String, filterDate: Date? = nil){
        self.isLoading = true
        var filteredData: [FeedDetailModel] = []
        
        guard url != "" else { return }
  
        let feedURL = URL(string: url)!
        
        let parser = FeedParser(URL: feedURL)
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            // Do your thing, then back to the Main thread
            DispatchQueue.main.async { [self] in
                let result = parser.parse()
                
                switch result {
                case .success(let feed):
                    
                    switch feed {
                        case let .atom(feed):       // Atom Syndication Format Feed Model
                        
                            if let items = feed.entries {
                                for item in items {
                                    let firstLink = item.links?.first
                                    filteredData.append(FeedDetailModel(
                                        title: item.title,
                                        description: item.summary?.value,
                                        url: (firstLink != nil) ? firstLink?.attributes?.href : "",
                                        date: item.published
                                    ))
                                }
                                
                            }
                        case let .rss(feed):        // Really Simple Syndication Feed Model
                            if let items = feed.items {
                                for item in items {
                                    filteredData.append(FeedDetailModel(
                                        title: item.title,
                                        description: item.description,
                                        url: item.link,
                                        date: item.pubDate
                                    ))
                                }
                                
                   
                                
                            }
                           
                        case let .json(feed):       // JSON Feed Model
                            if let items = feed.items {
                               for item in items {
                                   filteredData.append(FeedDetailModel(
                                       title: item.title,
                                       description: item.summary,
                                       url: item.url,
                                       date: item.datePublished
                                   ))
                               }
                                
                           }
                    
                        
                    }
                    
                case .failure(_):
                    print("error")
                }
                
                
                if let filterDate = filterDate {
                    filteredData = filteredData.filter { item in return (item.date ?? Date.now > filterDate) }
                    self.data += filteredData
                } else {
                    self.data += filteredData
                }
              
                self.isLoading = false

            }
        }
    }
    
    func getNewData(feedModel: [FeedModel], showAll: Bool = false) {
        self.data = []
        for feed in feedModel {
            self.getData(url: feed.url, filterDate: feed.lastSeen)
        }
        
        
    }
    

}


