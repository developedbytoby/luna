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
    @State private var request: String = ""
    @State private var response: String = ""

    @State private var messages: [MessageChatGPT]

    init() {
        self.messages = [
            MessageChatGPT(text: "You are a helpful assistant.", role: .system),
            MessageChatGPT(text: "Say hi", role: .user)
        ]
    }
    
    let params = ChatCompletionsOptionalParameters(temperature: 0.7, maxTokens: 50)
    
    var body: some View {
        VStack {
            TextField("Enter your message", text: $request)
                .padding()
            Text(response)
                .padding()
            
            Button("Ask anything") {
                Task {
                    do {
                        let chatCompletions = try await openAI.createChatCompletions(model: .gpt3_5(.turbo), messages: messages, optionalParameters: params)
                        // response = chatCompletions?.choices.message.content as? String
                        print(chatCompletions?.choices)
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            
        }
        .padding()
    }
}

func askAI() {
    
}

#Preview {
    ContentView()
}
