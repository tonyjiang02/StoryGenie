//
//  StoryView.swift
//  TellMeAStory
//
//  Created by Tony Jiang on 3/3/24.
//

import SwiftUI
struct StoryView: View {
    @ObservedObject var storyViewModel = StoryViewModel.shared
    @State var isLoading = true
    var body: some View {
        if isLoading {
            Text("Loading ...").font(.title).onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    isLoading = false
                }
            }
        } else {
            CarouselView(stories: storyViewModel.story)
        }
        
    }
}

struct CarouselView: View {
    var items: [CarouselItem]
    init(stories: [String]) {
        items = []
        var i = 0
        for story in stories {
            if i != 0 {
                items.append(CarouselItem(image: "dalle\(i)", text: story))
            } else {
                items.append(CarouselItem(image: "test", text: story))
            }
            i = i+1
        }
    }
    @State private var currentIndex: Int = 0
    var body: some View {
        VStack {
            ScrollViewReader { value in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(items) { item in
                            VStack {
                                Image(item.image).resizable().aspectRatio(contentMode: .fit)
                                Text(item.text)
                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width - 30)
                        }
                    }
                    .padding()
                }
                Button("Next Page") {
                    currentIndex = (currentIndex + 1) % items.count
                    withAnimation {
                        value.scrollTo(items[currentIndex].id, anchor: .center)
                    }
                }
            }
        }
    }
}
struct CarouselItem: Identifiable {
    let id = UUID()
    let image: String // Assuming image names for local assets
    let text: String
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StoryView()
    }
}
