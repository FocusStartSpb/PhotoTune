//
//  EditingScreenMainView+UICollectionViewDataSource.swift
//  PhotoTune
//
//  Created by Mikhail Medvedev on 23.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

extension EditingScreenMainView: UICollectionViewDataSource
{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		toolCollectionViewDataSource?.itemsCount ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let title = toolCollectionViewDataSource?.cellTitleFor(index: indexPath.item)
		let image = toolCollectionViewDataSource?.cellImageFor(index: indexPath.item)

		switch toolCollectionViewDataSource?.editingType {
		case .filters:
			if let filterCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: FiltersCollectionViewCell.identifier,
				for: indexPath) as? FiltersCollectionViewCell {

				filterCell.setTitle(title ?? "")
				filterCell.setImage(image)

				return filterCell
			}
		case .tune:
			if let tuneToolCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: TuneToolCollectionViewCell.identifier,
				for: indexPath) as? TuneToolCollectionViewCell {
				tuneToolCell.setImage(image)
				tuneToolCell.setTitle(title ?? "")
				return tuneToolCell
			}
		default: break
		}

		return UICollectionViewCell()
}
}
