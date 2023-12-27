//
//  ContentView.swift
//  Luna Watch App
//
//  Created by Toby Brown on 27/12/2023.
//

import SwiftUI
import SwiftOpenAI
import Foundation

struct Config {
    static var openAIKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist") else {
                fatalError("Couldn't find file 'Config.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "OpenAI_API_Key") as? String else {
                fatalError("Couldn't find key 'OpenAI_API_Key' in 'Config.plist'.")
            }
            return value
        }
    }
}

var openAI = SwiftOpenAI(apiKey: Config.openAIKey)

struct ContentView: View {
    @State private var userInput: String = ""
    @State private var response: String = ""
    var body: some View {
        VStack {
            TextField("Enter your message", text: $userInput)
                .padding()
            Text(response)
                .padding()
            
            Button("Send Message") {
                sendMessage()
            }
        }
        .padding()
    }
}

func sendMessage() {
    Task {
        do {
            for try await newMessage in try await openAI.createChatCompletionsStream(model: .gpt3_5(.turbo),
                                                                                     messages: [.init(text: "Say hello!", role: .user)],
                                                                                     optionalParameters: .init(stream: true)) {
                            response = newMessage.replies.first?.content ?? "No response :("
                            print("New Message Received: \(newMessage) ")
                        }
                    } catch {
                        print(error)
                    }
                }
}

#Preview {
    ContentView()
}
