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
	func makeUIViewController(context: Context) -> UINavigationController {
		let pickerViewController = MCEmojiPickerViewController()
		pickerViewController.delegate = context.coordinator
		pickerViewController.navigationItem.backButtonDisplayMode = .minimal
		let navigationController = UINavigationController(rootViewController: pickerViewController)
		
		let navigationBarAppearance = UINavigationBarAppearance()
		navigationBarAppearance.backgroundColor = .systemBackground
		navigationBarAppearance.shadowColor = .clear
		
		navigationController.navigationBar.standardAppearance = navigationBarAppearance
		navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
		
		return navigationController
    }
	
	func makeCoordinator() -> Coordinator {
		Coordinator.init()
	}
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    
    
    typealias UIViewControllerType = UINavigationController
	
	final class Coordinator: MCEmojiPickerDelegate {
		
		func didGetEmoji(emoji: String) {
			
		}
	}
}

#Preview {
    ContentView()
}
