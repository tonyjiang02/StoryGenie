//
//  StoryViewModel.swift
//  TellMeAStory
//
//  Created by Tony Jiang on 3/3/24.
//

import Foundation

class StoryViewModel: ObservableObject {
    private let llmService = LLMService()
    static let shared = StoryViewModel()
    @Published var story: [String] = ["Title: Lily and the Magical Forest", "Once upon a time, in a land not too far away, there was a young girl named Lily who lived near a lush and vibrant forest. As the seasons passed by, Lily watched with wonder as the forest bloomed with colorful flowers, shimmered in the sunlight, and whispered with the rustling of leaves.", "One day, Lily noticed a change in the forest. The once vibrant colors began to fade, and the trees seemed to droop with exhaustion. Concerned, Lily decided to explore deeper into the forest to find out what was happening.", "As she wandered through the forest, she discovered that the animals were growing weary from a lack of clean water and healthy food. The streams that once ran clear were now polluted with trash, and the air was thick with smoke from factories.", "Determined to help, Lily set out to find a solution. She started by picking up trash along the streams and educating the animals about the importance of recycling and protecting their home. She also spoke to the humans living nearby, explaining how their actions were impacting the forest and its inhabitants.", "Her efforts started to make a difference. The animals began to work together to clean up the streams, and the humans started to plant trees and reduce their waste. Slowly but surely, the forest started to heal and thrive once again.", "As each day passed, Lily saw the forest return to its former glory. The trees stood tall and proud, the animals frolicked in the clear streams, and the air was filled with the sweet scent of flowers.", "The forest had become a shining example of how nature and humans could coexist in harmony, thanks to the efforts of one determined little girl named Lily.", "And so, Lily learned that by caring for and respecting the environment, we can all create a better world for ourselves and future generations to come."]
    @Published var images: [String] = []
    func createStory(tokens: [String]) {
        llmService.fetchData(strings: tokens) { response in
            if let response = response {
                self.story = response
                print(self.story)
                for line in self.story {
                    self.createImage(string: line)
                }
            }
        }
    }
    func createImage(string: String) {
//        llmService.fetchImage(string: string) { response in
//            if let response = response {
//                self.images.append(response)
//            }
//        }
    }
}
