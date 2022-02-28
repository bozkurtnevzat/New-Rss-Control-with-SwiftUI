//
//  NotefiedView.swift
//  Rss Feed Notifier
//
//  Created by Nevzat BOZKURT on 26.02.2022.
//

import SwiftUI

struct NewFeedsView: View {
    @ObservedObject var feedDetail = FeedDetailViewModel()
    @State var openWebUrl: String = ""
    @State var show = false

    func getNewFeed(){
        let feed = FeedViewModel()
        feedDetail.getNewData(feedModel: feed.data)
    }
    
    var body: some View {
        NavigationView {
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
                        Text("All Seen")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .onTapGesture {
                                let feedModel = FeedViewModel()
                                feedModel.allSeen()
                                
                                self.getNewFeed()
                            }
                    }.listStyle(.plain)
                } else {
                    Spacer()
                    if(feedDetail.isLoading) {
                        ProgressView()
                            .scaleEffect(1.5)
                    } else {
                        Text("No New Feeds.")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Button("Refresh") {
                            self.getNewFeed()
                        }
                    }
                    Spacer()
                }
                
            }.navigationTitle("New Feeds")
        }
        .sheet(isPresented: $show, onDismiss: {show = false}, content: {
            SAWebView(url: $openWebUrl)
        })
        .onAppear {
            self.getNewFeed()
            
        }
    }
}

struct NotefiedView_Previews: PreviewProvider {
    static var previews: some View {
        NewFeedsView()
    }
}
