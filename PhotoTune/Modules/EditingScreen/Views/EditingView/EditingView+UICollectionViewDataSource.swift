//
//  EditingView+UICollectionViewDataSource.swift
//  PhotoTune
//
//  Created by Mikhail Medvedev on 23.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

protocol IToolCollectionViewDataSource: AnyObject
{
	var itemsCount: Int { get }
	var editingType: EditingType { get }

	func dataForFilterCell(index: Int) -> (title: String, image: UIImage?)
	func dataForTuneCell(index: Int) -> TuneTool
	func showChangesIndicator(for tuneTool: TuneTool?) -> Bool?
}

extension EditingView: UICollectionViewDataSource
{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		toolCollectionViewDataSource?.itemsCount ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		switch toolCollectionViewDataSource?.editingType {
		case .filters:
			if let filterCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: FiltersCollectionViewCell.identifier,
				for: indexPath) as? FiltersCollectionViewCell {

				let filter = toolCollectionViewDataSource?.dataForFilterCell(index: indexPath.item)

				filterCell.setTitle(filter?.title ?? "")
				filterCell.setImage(filter?.image)

				return filterCell
			}
		case .tune:
			if let tuneToolCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: TuneToolCollectionViewCell.identifier,
				for: indexPath) as? TuneToolCollectionViewCell {
				let tuneTool = toolCollectionViewDataSource?.dataForTuneCell(index: indexPath.item)
				tuneToolCell.tuneTool = tuneTool
				tuneToolCell.isIndicatorShown = toolCollectionViewDataSource?.showChangesIndicator(for: tuneTool) ?? false
				return tuneToolCell
			}
		default: break
		}

		return UICollectionViewCell()
}
}
