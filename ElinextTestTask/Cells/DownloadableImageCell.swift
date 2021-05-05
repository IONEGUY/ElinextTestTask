//
//  DownloadableImageCell.swift
//  ElinextTestTask
//
//  Created by MacBook on 2.05.21.
//

import Foundation
import UIKit

class DownloadableImageCell: UICollectionViewCell {
    var loading = false
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
         
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        loading = false
    }
    
    func setupUI() {
        layer.cornerRadius = 7
        clipsToBounds = true
        
        setupViews()
        setupConstraints()
    }
    
    func load(with url: String, name: String) {
        activityIndicator.startAnimating()
        if loading { return }
        loading = true
        ImageLoaderHelper.loadImage(with: url, into: imageView, cacheName: name) { [unowned self] in
            activityIndicator.stopAnimating()
            loading = false
        }
    }
    
    private func setupViews() {
        addSubview(activityIndicator)
        addSubview(imageView)
    }
    
    private func setupConstraints() {
        imageView.fillSuperview()
        activityIndicator.fillSuperview()
    }
}
