//
//  CollectionViewLayout.swift
//  PhotoTune
//
//  Created by Саша Руцман on 21/12/2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

final class CustomCollectionViewLayout
{
	func getLayout() -> UICollectionViewFlowLayout {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 30, height: UIScreen.main.bounds.width / 2 - 30)
		layout.minimumInteritemSpacing = 20
		layout.minimumLineSpacing = 20
		layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
		return layout
	}
}
