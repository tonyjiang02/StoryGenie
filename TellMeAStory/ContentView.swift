//
//  ContentView.swift
//  TellMeAStory
//
//  Created by Tony Jiang on 3/3/24.
//

import SwiftUI

// tell me a story you'd like to hear
// have bubbles that can be suggestions
// this will pass a story prompt into a observed object, that will store the story lines
struct ContentView: View {
    @ObservedObject var storyViewModel = StoryViewModel.shared
    @State var categoryText = ""
    @State var presentStoryPage = false
    @FocusState private var categoryFieldFocused: Bool
    @State private var categoryFieldShown: Bool = false
    @State var categories: [Category] = [
        Category(text: "Nature"), Category(text: "Peace"), Category(text: "Environment"), Category(text: "Love"), Category(text: "Family")
    ]
    let gridItems = [GridItem(.adaptive(minimum:120))]
    var body: some View {
        NavigationStack {
            VStack {
                Image("Logo").resizable().aspectRatio(contentMode: .fit).frame(height: 200)
                Spacer()
                Text("What is your story about?")
                LazyVGrid(columns: gridItems, spacing: 0) {
                    ForEach(categories.indices, id: \.self) { index in
                        RoundedRectangleCategory(category: $categories[index])
                    }
                }
                Button(action: {
                    categoryFieldFocused = true
                    categoryFieldShown = true
                    categoryText = ""
                }) {
                    HStack {
                        Text("Add Category")
                        Image(systemName: "plus")
                    }
                    
                }.padding()
                Button(action: {
                    submitStory()
                }, label: {
                    Text("Submit").foregroundStyle(.black).padding().background(RoundedRectangle(cornerRadius: 10.0).fill(.white).stroke(.black))
                }).navigationDestination(isPresented: $presentStoryPage) {
                    StoryView()
                }
                Spacer()
                VStack {
                    Button("Done") {
                        // save category text
                        categories.append(Category(text: categoryText, tapped: true))
                        categoryFieldShown = false
                        categoryFieldFocused = false
                    }
                    TextField("Enter Category", text: $categoryText)
                        .padding()
                        .focused($categoryFieldFocused)
                }.visible(categoryFieldShown)
            }
            .padding()
        }
    }
    func submitStory() {
        print("Submitting story")
        // get all selected categories
        let selectedCategories = categories.filter {$0.tapped}
        let selectedCategoryStrings = selectedCategories.map {$0.text}
        storyViewModel.createStory(tokens: selectedCategoryStrings)
        presentStoryPage = true
    }
}
struct RoundedRectangleCategory: View {
    @Binding var category: Category
    var body: some View {
        VStack {
            Text(category.text)
                .foregroundStyle(category.tapped ? .white : .black)
                .padding()
                .lineLimit(1)
                .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2)
                    .fill(category.tapped ? .black : .white)
                    .frame(height: 40)
                    .onTapGesture {
                        category.tapped.toggle()
                    }
            )
        }
    }
}
struct Category: Identifiable {
    let id = UUID()
    var text: String
    var tapped = false
}

extension View {
    func visible(_ isVisible: Bool) -> some View {
        self.modifier(VisibilityModifier(isVisible: isVisible))
    }
}

private struct VisibilityModifier: ViewModifier {
    let isVisible: Bool
    
    func body(content: Content) -> some View {
        if isVisible {
            return AnyView(content)
        } else {
            return AnyView(EmptyView())
        }
    }
}

#Preview {
    ContentView()
}
