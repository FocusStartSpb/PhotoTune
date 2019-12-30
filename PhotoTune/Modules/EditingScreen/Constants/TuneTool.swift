//
//  TuneToolsImages.swift
//  PhotoTune
//
//  Created by Mikhail Medvedev on 23.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

enum TuneTool: CaseIterable, Equatable
{
	typealias AllCases = [TuneTool]

	static var allCases: [TuneTool] {
		return [
			TuneTool.brightness(),
			TuneTool.contrast(),
			TuneTool.saturation(),
			TuneTool.vignette(),
		]
	}

	var values: (title: String, image: UIImage?) {
		switch self {
		case .brightness(let title, let image),
			 .contrast(let title, let image),
			 .saturation(let title, let image),
			 .vignette(let title, let image):
			return (title, image)
		}
	}

	case brightness(title: String = "Brightness", image: UIImage? = UIImage(named: "brightness"))

	case contrast(title: String = "Contrast", image: UIImage? = UIImage(named: "contrast"))

	case saturation(title: String = "Saturation", image: UIImage? = UIImage(named: "saturation"))

	case vignette(title: String = "Vignette", image: UIImage? = UIImage(named: "vignette"))
}
