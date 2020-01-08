//
//  EditedImagesScreenCell.swift
//  PhotoTune
//
//  Created by MacBook Air on 22.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

final class EditedImagesScreenCell: ImageCollectionViewCell
{
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureCell()
	}

	private func configureCell() {
		imageView.contentMode = .center
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = 20
	}
}
