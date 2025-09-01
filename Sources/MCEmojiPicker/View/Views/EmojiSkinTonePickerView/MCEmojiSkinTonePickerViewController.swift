//
//  MCEmojiSkinTonePickerViewController.swift
//  MCEmojiPicker
//
//  Created by Jaylen Smith on 12/1/24.
//

import UIKit

public class MCEmojiSkinTonePickerViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(MCEmojiSkinToneCell.self, forCellWithReuseIdentifier: "MCEmojiSkinToneCell")
        collectionView.isUserInteractionEnabled = true
        collectionView.allowsSelection = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()
	
	private let closeButton: UIButton = {
		let button = UIButton(type: .close)
		button.accessibilityLabel = "Close"
		return button
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
    
	public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
    
    private func setupNavigationController() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Skin Tone"
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate   = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - UICollectionViewDelegate
extension MCEmojiSkinTonePickerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MCEmojiSkinTonePickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

//MARK: - UICollectionViewDataSource
extension MCEmojiSkinTonePickerViewController: UICollectionViewDataSource {
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let skinToneCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MCEmojiSkinToneCell", for: indexPath) as! MCEmojiSkinToneCell
        let emoji = skinToneEmojis[indexPath.row]
        skinToneCell.setupView(emoji: emoji)
        skinToneCell.onTap = { [weak self] in
            if let skinTone = MCEmojiSkinTone(rawValue: indexPath.row + 1) {
                self?.skinToneSelectionCompletion?(emoji, skinTone)
                self?.dismiss(animated: true)
            }
        }
        return skinToneCell
    }
    
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skinToneEmojis.count
    }
}

final class MCEmojiSkinToneCell: UICollectionViewCell {
    
    private var emojiLabelView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 35.fit())
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        self.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addGestureRecognizer(tapGesture)
        
        addSubview(emojiLabelView)
        
        NSLayoutConstraint.activate([
            emojiLabelView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiLabelView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc private func cellTapped() {
        print("Cell tapped!")
        onTap?()
    }
    
    func setupView(emoji: String) {
        self.emojiLabelView.text = emoji
    }
}
