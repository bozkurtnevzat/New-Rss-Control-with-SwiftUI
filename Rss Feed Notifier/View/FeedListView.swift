//
//  ContentView.swift
//  Rss Feed Notifier
//
//  Created by Nevzat BOZKURT on 22.02.2022.
//

import SwiftUI


struct FeedListView: View {
    @ObservedObject var feed = FeedViewModel()
   // @FocusState private var addUrlTextIsFocused: Bool
    @State var addFeedStep = 0
    @State var addUrlText = ""
    
    @State var isLoadingAddButton = false
    @State var feedTitle = ""
    
    //Alert
    @State var showsAlert = false
    @State var alertTitle = ""
    @State var alertContent = ""
    
    
    func saveBtn(){
        if feedTitle != "" {
            feed.addData(title: feedTitle, url: addUrlText)
            cancel()
        } else {
            alertTitle = "Title can't be empty."
            alertContent = "Please enter the Feed title."
            showsAlert.toggle()
        }
    }
    
    func nextBtn(){
        if (addUrlText != "" && (addUrlText.lowercased().index(of: "http") != nil) ) {
            
            if feed.findDataByUrl(url: addUrlText) == nil {
                isLoadingAddButton = true
                feed.getTitleByUrl(url: addUrlText) { title  in
                    if title != "-1" {
                        self.feedTitle = title
                        addFeedStep = 2
                        isLoadingAddButton = false
                    } else {
                        alertTitle = "Error"
                        alertContent = "Please check your Feed URL."
                        showsAlert.toggle()
                        isLoadingAddButton = false
                    }
                }
                
            } else {
                alertTitle = "It's on your list."
                alertContent = "Please enter a different Feed URL."
                showsAlert.toggle()
            }
            
           
        }  else {
            alertTitle = "Url Not Found"
            alertContent = "Please give me Feed URL."
            showsAlert.toggle()
            isLoadingAddButton = false
        }

    }
    
    func cancel(){
        addUrlText = ""
        addFeedStep = 0
    }
    
    var body: some View {
            NavigationView {
                VStack {
                    if (feed.data.count > 0){
                        List {
                            ForEach(feed.data) {data in
                                NavigationLink(destination: FeedDetailView(title: data.title, url: data.url)) {
                                    FeedListItem(title: data.title, url: data.url)
                                }
                            }
                            .onDelete { IndexSet in
                                feed.removeData(index: IndexSet)
                            }
                            .onMove { IndexSet, Int in
                                feed.moveData(from: IndexSet, to: Int)
                            }
                        }
                    } else {
                        Spacer()
                        VStack(alignment: .leading){
                            Text("No Feeds.")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)

                            Text("You can add the feed you want to receive notification from below.")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                            
                        Spacer()
                    }
                
                    VStack{
                        if (addFeedStep > 0){
                            TextField("Feed URL", text: $addUrlText, onCommit: nextBtn)
                                //.focused($addUrlTextIsFocused)
                                //.padding(8)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .shadow(radius: 3)
                                .offset(y:-12)
                                .textFieldStyle(.roundedBorder)
                                .opacity(addFeedStep == 1 ? 1 : 0)
                                .disabled(addFeedStep == 0)
                        }
                        
                        if (addFeedStep == 2){
                            TextField("Feed Title", text: $feedTitle, onCommit: saveBtn)
                                //.focused($addUrlTextIsFocused)
                                //.padding(8)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .shadow(radius: 3)
                                .offset(y:-12)
                                .textFieldStyle(.roundedBorder)
                                .opacity(addFeedStep == 2 ? 1 : 0)
                                .disabled(addFeedStep < 1)
                        }   
                           
                        VStack {
                            if addFeedStep > 0 {
                                HStack{
                                    Text("Cancel")
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 44)
                                        .background(.red)
                                        .foregroundColor(.black)
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        .onTapGesture {
                                            cancel()
                                        }
                                    
                                    if (isLoadingAddButton) {
                                        ProgressView()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 44)
                                            .background(.green)
                                            .foregroundColor(.black)
                                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                           
                                    } else {
                                        Text(addFeedStep == 1 ? "Next" : "Confirm Title")
                                            .bold()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 44)
                                            .background(.green)
                                            .foregroundColor(.black)
                                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                            .onTapGesture {
                                                if addFeedStep == 1 {
                                                    nextBtn()
                                                } else {
                                                    saveBtn()
                                                }
                                            }
                                    }
                                }
                            } else {
                                Text("Add Feeds")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(.blue)
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .onTapGesture {
                                        addFeedStep = 1
                                        //addUrlTextIsFocused = true
                                    }
                            }
                        }
                    
                    }
                    .padding()
                    .animation(.spring(), value: addFeedStep)
                }
                .navigationTitle("My Feeds")
                .toolbar {
                    EditButton()
                }
         
            }
            .listStyle(.plain)
            .alert(isPresented: self.$showsAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertContent),
                    dismissButton: .default(Text("Try again"))
                )
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FeedListView()
    }
}





