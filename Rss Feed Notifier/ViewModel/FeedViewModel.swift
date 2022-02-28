//
//  FeedViewModel.swift
//  Rss Feed Notifier
//
//  Created by Nevzat BOZKURT on 23.02.2022.
//

import SwiftUI
import FeedKit


class FeedViewModel: ObservableObject {
    @Published var data: [FeedModel] = []
    
    
    init(){
        getData()
    }
    
    func saveData(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            UserDefaults.standard.set(encoded, forKey: "feedData")
        }
    }
    
    func getData(){
        if let datas = UserDefaults.standard.object(forKey: "feedData") as? Data {
            let decoder = JSONDecoder()
            if let savedData = try? decoder.decode([FeedModel].self, from: datas) {
                self.data = savedData
            }
        }
    }
    
    func addData(title: String, url: String){
        self.data.append(FeedModel(title: title, url: url, lastSeen: Date.now))
        self.saveData()
    }
    
    func findDataByUrl(url: String) -> FeedModel? {
        if let i = data.firstIndex(where: { $0.url == url }) {
            return self.data[i]
        } else {
            return nil
        }
    }
    
    func removeData(index: IndexSet){
        if let index = index.first {
            self.data.remove(at: index)
            self.saveData()
        }
    }
    
    func moveData(from source: IndexSet, to destination: Int) {
        self.data.move(fromOffsets: source, toOffset: destination)
        self.saveData()
    }
    
    func allSeen() {
        for index in 0 ..< self.data.count {
            self.data[index].lastSeen = Date.now
        }
        self.saveData()
    }
    
    
    func getTitleByUrl(url: String, completion: @escaping (String) -> Void)  {
        guard url != "" else { return completion("Undefined Title") }
  
        let feedURL = URL(string: url)!
        
        let parser = FeedParser(URL: feedURL)
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            // Do your thing, then back to the Main thread
            DispatchQueue.main.async {
                let result = parser.parse()
                
                switch result {
                case .success(let feed):
                    switch feed {
                        case let .atom(feed):       // Atom Syndication Format Feed Model
                        completion(feed.title ?? "")
                        case let .rss(feed):        // Really Simple Syndication Feed Model
                        completion(feed.title ?? "")
                        case let .json(feed):       // JSON Feed Model
                        completion(feed.title ?? "")
                    }
                case .failure(_):
                    completion("-1")
                }
            }
        }
    }
    
}
