//
//  FeedDetail.swift
//  Rss Feed Notifier
//
//  Created by Nevzat BOZKURT on 22.02.2022.
//

import SwiftUI
import FeedKit


struct FeedDetailView: View {
    @ObservedObject var feedDetail = FeedDetailViewModel()
    @State var openWebUrl: String = ""
    @State var show = false
    var title: String = "Feed Details"
    var url: String
    
    var body: some View {
        VStack {
            if (feedDetail.data.count > 0){
                List {
                    ForEach(feedDetail.data) {data in
                        FeedListItem(title: data.title ?? "", url: "", description: data.description ?? "")
                            .onTapGesture {
                                if let url = data.url {
                                    openWebUrl = url
                                    show = true
                                }
                            }
                    }
                }
            } else {
                Spacer()
                ProgressView()
                    .scaleEffect(1.5)
                Spacer()
            }
            
        }
        .sheet(isPresented: $show, onDismiss: {show = false}, content: {
            SAWebView(url: $openWebUrl)
        })
        .navigationTitle(title)
        .onAppear {
            feedDetail.getData(url: url)
        }
        
    }
}


