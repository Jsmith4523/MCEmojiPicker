//
//  MCEmojiSkinTonePickerViewController.swift
//  MCEmojiPicker
//
//  Created by Jaylen Smith on 12/1/24.
//

import UIKit

class MCEmojiSkinTonePickerViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(MCEmojiSkinToneCell.self, forCellWithReuseIdentifier: "MCEmojiSkinToneCell")
        return collectionView
    }()
    
    private var emoji: MCEmoji?
    
    private var skinToneEmojis: [String] {
        MCEmojiSkinTone.allCases.map {
            var emojiKey = emoji?.emojiKeys ?? []
            if let skinToneKey = $0.skinKey {
                emojiKey.insert(skinToneKey, at: 1)
            }
            return emojiKey.emoji()
        }
    }
    
    var skinToneSelectionCompletion: ((String, MCEmojiSkinTone) -> Void)?
    
    init(emoji: MCEmoji?) {
        super.init(nibName: nil, bundle: .main)
        self.emoji = emoji
        self.setupNavigationController()
        self.setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Skin Tone"
        navigationItem.largeTitleDisplayMode = .never
        
        let closeNavigationItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = closeNavigationItem
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate   = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc
    private func dismissViewController() {
        dismiss(animated: true)
    }
}

//MARK: - UICollectionViewDelegate
extension MCEmojiSkinTonePickerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let skinTone = MCEmojiSkinTone(rawValue: indexPath.row + 1) {
            let emoji = skinToneEmojis[indexPath.row]
            skinToneSelectionCompletion?(emoji, skinTone)
        }
    }
}

//MARK: - UICollectionViewDataSource
extension MCEmojiSkinTonePickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let skinToneCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MCEmojiSkinToneCell", for: indexPath) as! MCEmojiSkinToneCell
        let emoji = skinToneEmojis[indexPath.row]
        skinToneCell.setupView(emoji: emoji)
        return skinToneCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skinToneEmojis.count
    }
}

final class MCEmojiSkinToneCell: UICollectionViewCell {
    
    private var emojiLabelView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 35.fit())
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupView(emoji: String) {
        self.emojiLabelView.text = emoji
        
        addSubview(emojiLabelView)
        
        NSLayoutConstraint.activate([
            emojiLabelView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiLabelView.centerYAnchor.constraint(equalTo: centerYAnchor),
            emojiLabelView.widthAnchor.constraint(equalToConstant: 50),
            emojiLabelView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
