//
//  ContentView.swift
//  TestEmojiPicker
//
//  Created by Jaylen Smith on 1/13/25.
//

import SwiftUI
import MCEmojiPicker

struct ContentView: View {
    var body: some View {
        EmojiPickerView()
    }
}

fileprivate struct EmojiPickerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MCEmojiPicker.MCEmojiPickerViewController {
        MCEmojiPickerViewController()
    }
    
    func updateUIViewController(_ uiViewController: MCEmojiPicker.MCEmojiPickerViewController, context: Context) {}
    
    
    typealias UIViewControllerType = MCEmojiPickerViewController
}

#Preview {
    ContentView()
}
