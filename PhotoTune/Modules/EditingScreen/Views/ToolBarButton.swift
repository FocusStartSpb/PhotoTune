//
//  ToolBarButton.swift
//  PhotoTune
//
//  Created by Mikhail Medvedev on 19.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

final class ToolBarButton: UIButton
{
	var editingType: EditingType?

	override var isSelected: Bool {
		didSet {
			UIView.animate(withDuration: 0.25) {
				self.backgroundColor = self.isSelected ? UIColor.gray.withAlphaComponent(0.5) : .clear
			}
		}
	}

	init() {
		super.init(frame: .zero)
		frame.size.width = 50
		frame.size.height = 50
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
