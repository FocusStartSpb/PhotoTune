//
//  GoogleSearchScreenViewController.swift
//  PhotoTune
//
//  Created by Саша Руцман on 08.01.2020.
//  Copyright © 2020 Mikhail Medvedev. All rights reserved.
//

import UIKit

protocol IGoogleSearchScreenViewController
{
	func updateCellImage(index: Int, image: UIImage)
	func updatePhotosArray(photosInfo: [GoogleImage])
}

final class GoogleSearchScreenViewController: UIViewController
{
	private let presenter: IGoogleSearchScreenPresenter
	private var timer: Timer?
	private let searchController = UISearchController(searchResultsController: nil)
	private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	private let layout = CustomCollectionViewLayout()
	private var photos = [GoogleImage]()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		self.title = "Search"
		setupSearchBar()
		setupCollectionView()
		presenter.getRandomImages()
	}

	init(presenter: IGoogleSearchScreenPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupSearchBar() {
		searchController.obscuresBackgroundDuringPresentation = false
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.searchBar.delegate = self
		searchController.definesPresentationContext = true
		if #available(iOS 13.0, *) {
			searchController.searchBar.tintColor = .label
		}
		else {
			searchController.searchBar.tintColor = .black
		}
	}

	private func setupCollectionView() {
		collectionView.backgroundColor = .white
		layout.delegate = self
		collectionView.collectionViewLayout = layout
		collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "photoCell")
		collectionView.dataSource = self
		collectionView.delegate = self
		view.addSubview(collectionView)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}

	private func presentAlert(index: Int) {
		let alert = UIAlertController(title: "Select an image",
									  message: "By clicking on the \"Select\" button, you will enter the editing mode",
									  preferredStyle: .alert)
		let selectAction = UIAlertAction(title: "Select", style: .default) { _ in
			self.presenter.loadImage(urlString: self.photos[index].urls.regular, index: index, cell: false)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(cancelAction)
		alert.addAction(selectAction)
		present(alert, animated: true)
	}
}

extension GoogleSearchScreenViewController: UISearchBarDelegate
{
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 0.5,
									 repeats: false,
									 block: { _ in
										self.presenter.getImages(with: searchText)
		})
	}
}

extension GoogleSearchScreenViewController: IGoogleSearchScreenViewController
{
	func updateCellImage(index: Int, image: UIImage) {
		guard let cell = self.collectionView.cellForItem(at: IndexPath(row: index,
																	   section: 0)) as? ImageCollectionViewCell else { return }
		cell.imageView.image = image
	}

	func updatePhotosArray(photosInfo: [GoogleImage]) {
		self.photos = photosInfo
		self.collectionView.reloadData()
	}
}

extension GoogleSearchScreenViewController: UICollectionViewDataSource
{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell",
														for: indexPath) as? ImageCollectionViewCell
		guard let cell = photoCell else { return UICollectionViewCell() }
		presenter.loadImage(urlString: photos[indexPath.item].urls.small, index: indexPath.item, cell: true)
		cell.layoutIfNeeded()
		return cell
	}
}

extension GoogleSearchScreenViewController: UICollectionViewDelegate
{
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		presentAlert(index: indexPath.item)
	}
}

extension GoogleSearchScreenViewController: CustomCollectionViewLayoutDelegate
{
	func collectionView(_ layout: CustomCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let photo = photos[indexPath.item]
		return CGSize(width: photo.width, height: photo.height)
	}
}
