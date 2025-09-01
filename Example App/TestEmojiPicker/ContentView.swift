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
		let navigationController = GestureNavigationController(rootViewController: pickerViewController)
		navigationController.delegate = navigationController
		
		let navigationBarAppearance = UINavigationBarAppearance()
		navigationBarAppearance.backgroundColor = .systemBackground
		navigationBarAppearance.shadowColor = .clear
		
		pickerViewController.navigationItem.backButtonDisplayMode = .minimal
		navigationController.navigationBar.tintColor = .label
		
		navigationController.navigationBar.standardAppearance = navigationBarAppearance
		navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
		
		return navigationController
    }
	
	func makeCoordinator() -> Coordinator {
		Coordinator.init()
	}
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    
    
    typealias UIViewControllerType = UINavigationController
	
	final class Coordinator: NSObject, MCEmojiPickerDelegate, UIGestureRecognizerDelegate {
		
		func didGetEmoji(emoji: String) {
			
		}
	}
}

public class GestureNavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
	
	let precentDrivenAnimator = UIPercentDrivenInteractiveTransition()
	
	public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
		if operation == .push, toVC is MCEmojiSkinTonePickerViewController {
			return PopInAnimator()
		} else if operation == .pop, fromVC is MCEmojiSkinTonePickerViewController {
			return PopOutAnimator()
		}
		return nil
	}
}

final class PopInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	let duration: TimeInterval = 0.3

	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard
			let toVC = transitionContext.viewController(forKey: .to),
			let fromVC = transitionContext.viewController(forKey: .from) as? MCEmojiPickerViewController,
			let emojiFrameInWindow = fromVC.emojiCellFrameInWindow
		else {
			transitionContext.completeTransition(false)
			return
		}

		let container = transitionContext.containerView
		let finalFrame = transitionContext.finalFrame(for: toVC)
		
		// Convert the emoji center to container coordinates
		let emojiCenter = CGPoint(x: emojiFrameInWindow.midX, y: emojiFrameInWindow.midY)
		let emojiCenterInContainer = container.convert(emojiCenter, from: nil)

		// Set initial frame (tiny centered view at the emoji tap point)
		let initialSize = CGSize(width: 20, height: 20) // starting size
		let initialOrigin = CGPoint(
			x: emojiCenterInContainer.x - initialSize.width / 2,
			y: emojiCenterInContainer.y - initialSize.height / 2
		)

		toVC.view.frame = CGRect(origin: initialOrigin, size: initialSize)
		toVC.view.clipsToBounds = true
		toVC.view.layer.cornerRadius = 12 // optional for polish
		container.addSubview(toVC.view)

		// Animate to full size
		UIView.animate(withDuration: duration,
					   delay: 0,
					   usingSpringWithDamping: 0.8,
					   initialSpringVelocity: 0.6,
					   options: .curveEaseInOut,
					   animations: {
			toVC.view.frame = finalFrame
			toVC.view.layer.cornerRadius = 0
		}) { finished in
			transitionContext.completeTransition(finished)
		}
	}
}

final class PopOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	let duration: TimeInterval = 0.5

	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard
			let fromVC = transitionContext.viewController(forKey: .from),
			let toVC = transitionContext.viewController(forKey: .to) as? MCEmojiPickerViewController
		else {
			transitionContext.completeTransition(false)
			return
		}

		let container = transitionContext.containerView
		container.insertSubview(toVC.view, belowSubview: fromVC.view) // 👈 Add this!

		UIView.animate(withDuration: duration,
					   delay: 0,
					   usingSpringWithDamping: 0.7,
					   initialSpringVelocity: 0.8,
					   options: .curveEaseInOut) {
			
			if let emojiCellFrameInWindow = toVC.emojiCellFrameInWindow {
				let emojiCenter = CGPoint(x: emojiCellFrameInWindow.midX, y: emojiCellFrameInWindow.midY)
				let emojiCenterInContainer = container.convert(emojiCenter, from: nil)
				let initialOrigin = CGPoint(
					x: emojiCenterInContainer.x,
					y: emojiCenterInContainer.y
				)
				
				fromVC.view.frame = CGRect(origin: initialOrigin, size: .init(width: 0, height: 0))
			} else {
				fromVC.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
			}
		} completion: { finished in
			fromVC.view.removeFromSuperview()
			transitionContext.completeTransition(finished)
		}
	}
}

#Preview {
    MCEmojiPickerViewController()
}
