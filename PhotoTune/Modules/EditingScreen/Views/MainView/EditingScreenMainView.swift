//
//  EditingScreenMainView.swift
//  PhotoTune
//
//  Created by Mikhail Medvedev on 23.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

protocol IToolCollectionViewDelegate: AnyObject
{
	func imageWithFilter(index: Int) -> UIImage?
}

protocol IToolCollectionViewDataSource: AnyObject
{
	var itemsCount: Int { get }
	var editingType: EditingType { get }

	func cellTitleFor(index: Int) -> String
	func cellImageFor(index: Int) -> UIImage?
}

final class EditingScreenMainView: UIView
{
	private let imageView = UIImageView()
	private let editingView = UIView()

	private let filtersTools = ToolsCollectionView()
	private let tuneTools = ToolsCollectionView()
	private let rotationTool = RotationView()

	weak var toolCollectionViewDelegate: IToolCollectionViewDelegate?
	weak var toolCollectionViewDataSource: IToolCollectionViewDataSource?

	var heightForCell: CGFloat {
		if toolCollectionViewDataSource?.editingType == .filters {
			return imageView.bounds.height / 3
		}
		else {
			return imageView.bounds.height / 5
		}
	}

	var spacingForCell: CGFloat {
		if toolCollectionViewDataSource?.editingType == .filters {
			return 10
		}
		else {
			return 100
		}
	}

	init() {
		super.init(frame: .zero)
		setDelegateWithDataSource()
		setupView()
		setConstraints()
		addTools()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setDelegateWithDataSource() {
		filtersTools.delegate = self
		filtersTools.dataSource = self
		tuneTools.delegate = self
		tuneTools.dataSource = self
	}

	private func setupView() {
		if #available(iOS 13.0, *){
			backgroundColor = .systemBackground
		}
		else { backgroundColor = .white }
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFit
		imageView.layer.cornerRadius = EditingScreenMetrics.filterCellCornerRadius
		addSubview(imageView)
		addSubview(editingView)
	}

	private func setConstraints() {
		imageView.translatesAutoresizingMaskIntoConstraints = false
		editingView.translatesAutoresizingMaskIntoConstraints = false

		imageView.anchor(top: safeAreaLayoutGuide.topAnchor,
						 leading: leadingAnchor,
						 bottom: nil,
						 trailing: trailingAnchor)

		imageView.heightAnchor.constraint(
			equalTo: safeAreaLayoutGuide.heightAnchor,
			multiplier: 0.66).isActive = true

		editingView.anchor(top: imageView.bottomAnchor,
								  leading: leadingAnchor,
								  bottom: safeAreaLayoutGuide.bottomAnchor,
								  trailing: trailingAnchor)
	}

	private func addTools() {
		editingView.addSubview(filtersTools)
		filtersTools.fillSuperview()
		editingView.addSubview(tuneTools)
		tuneTools.fillSuperview()
	}

	func setImage(_ image: UIImage) {
		imageView.image = image
	}

	func hideAllToolsViews(except: EditingType) {
		editingView.subviews.forEach { $0.isHidden = true }
		switch except {
		case .filters:
			filtersTools.reloadData()
			filtersTools.selectItem(at: filtersTools.lastSelection, animated: false, scrollPosition: [])
			filtersTools.animatedAppearing()
		case .tune:
			tuneTools.reloadData()
			tuneTools.animatedAppearing()
		case .rotation: rotationTool.animatedAppearing()
		}
	}
}
