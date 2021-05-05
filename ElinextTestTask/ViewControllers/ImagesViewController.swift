//
//  ViewController.swift
//  ElinextTestTask
//
//  Created by MacBook on 30.04.21.
//

import UIKit

class ImagesViewController: UICollectionViewController {
    private let columnsCount: Int = 7
    private let rowsCount: Int = 10
    private let imagesCount = 140
    private let url = "https://loremflickr.com/200/200/"
    
    private var currentImagesCount = 0
    
    convenience init() {
        self.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentImagesCount = imagesCount
        
        setupRightBarButtonItems()
        
        ImageLoaderHelper.clearCache()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupCollectionView()
    }
    
    private func setupRightBarButtonItems() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Reload All", style: .plain, target: self, action: #selector(reloadAllImages)),
            UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewImage))
        ]
    }
    
    private func setupCollectionView() {
        collectionView.register(DownloadableImageCell.self, forCellWithReuseIdentifier: DownloadableImageCell.typeName)
        collectionView.collectionViewLayout = createLayout()
        collectionView.alwaysBounceVertical = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentImagesCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: DownloadableImageCell.typeName,
                                                      for: indexPath) as? DownloadableImageCell) ?? DownloadableImageCell()
        cell.load(with: url, name: "\(indexPath.row).jpg")        
        return cell
    }
    
    @objc private func reloadAllImages() {
        currentImagesCount = imagesCount
        ImageLoaderHelper.clearCache()
        collectionView.reloadData()
    }
    
    @objc private func addNewImage() {
        currentImagesCount += 1
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(row: currentImagesCount - 1, section: 0), at: .bottom, animated: true)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 1
        let fractionWidthValue = CGFloat(1 / columnsCount)
        let fractionHeightValue = CGFloat(1 / rowsCount)
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(fractionWidthValue),
            heightDimension: .fractionalHeight(1)
        ))
        
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(fractionHeightValue)),
            subitem: layoutItem,
            count: columnsCount)

        let rootGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1)),
            subitem: horizontalGroup,
            count: rowsCount
        )

        let layoutSection = NSCollectionLayoutSection(group: rootGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPaging
        
        return UICollectionViewCompositionalLayout(section: layoutSection)
    }
}
