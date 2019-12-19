//
//  CustomCollectionViewCell.swift
//  PhotoTune
//
//  Created by Саша Руцман on 19/12/2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell
{
	let imageView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(imageView)
		makeConstraintsForImageView()
	}
	
	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func makeConstraintsForImageView() {
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}
}

