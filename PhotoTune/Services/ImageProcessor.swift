//
//  ImageProcessor.swift
//  PhotoTune
//
//  Created by Mikhail Medvedev on 20.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

// MARK: - Protocols
protocol IImageProcessor: AnyObject
{
	var initialImage: UIImage? { get set }
	var tunedImage: UIImage? { get set }

	var tuneSettings: TuneSettings? { get set }
	var outputSource: IImageProcessorOutputSource? { get set }

	func makeFullSizeTunedImage(_ image: @escaping (UIImage?) -> Void)
	func clearContexCache()
	func filtersPreviews(image: UIImage) -> [(title: String, image: UIImage?)]
}

protocol IImageProcessorOutputSource: AnyObject
{
	func updateImage(image: UIImage?)
	func getOriginal(_ image: (UIImage?) -> Void)
}

// MARK: - ImageProcessor
final class ImageProcessor
{
	// MARK: Properties
	var outputSource: IImageProcessorOutputSource?

	var initialImage: UIImage? {
		didSet {
			if let image = initialImage {
				autoEnhanceFilters = CIImage(image: image)?.autoAdjustmentFilters()
			}
		}
	}

	var tunedImage: UIImage? { didSet { outputSource?.updateImage(image: tunedImage) } }

	var tuneSettings: TuneSettings? {
		didSet {
			throttler.throttle {
				self.appleTuneSettings()
			}
		}
	}

	// MARK: Private Properties
	private let throttler: Throttler
	private let context: CIContext
	private var currentCIImage: CIImage?
	private var autoEnhanceFilters: [CIFilter]?
	private var jpegData: Data? { initialImage?.jpegData(compressionQuality: 0.8) }
	private let screenSize = UIScreen.main.bounds

	init() {
		throttler = Throttler(minimumDelay: 0.0125)
		context = CIContext()
	}
}
// MARK: - Private Methods
private extension ImageProcessor
{
	func filteredImageForPreview(image: UIImage, with filter: CIFilter?) -> UIImage? {
		guard let filter = filter else { return image }
		let ciInput = CIImage(image: image)
		filter.setValue(ciInput, forKey: kCIInputImageKey)
		guard let ciOutput = filter.outputImage else { return nil }
		return UIImage(ciImage: ciOutput)
	}

	func photoFilter(ciInput: CIImage?) -> CIImage? {
		guard let photoFilter = CIFilter(name: tuneSettings?.ciFilter ?? "") else { return nil }
		photoFilter.setValue(ciInput, forKey: kCIInputImageKey)
		return photoFilter.outputImage
	}

	func colorControls(ciInput: CIImage?) -> CIImage? {
		guard let colorFilter = Filter.colorControls.ciFilter else { return nil }
		colorFilter.setValue(ciInput, forKey: kCIInputImageKey)
		colorFilter.setValue(tuneSettings?.brightnessIntensity, forKey: kCIInputBrightnessKey)
		colorFilter.setValue(tuneSettings?.saturationIntensity, forKey: kCIInputSaturationKey)
		colorFilter.setValue(tuneSettings?.contrastIntensity, forKey: kCIInputContrastKey)
		return colorFilter.outputImage
	}

	func sharpness(ciInput: CIImage?) -> CIImage? {
		guard let sharpFilter = Filter.sharpness.ciFilter else { return nil }
		sharpFilter.setValue(ciInput, forKey: kCIInputImageKey)
		sharpFilter.setValue(tuneSettings?.sharpnessIntensity, forKey: kCIInputIntensityKey)
		sharpFilter.setValue(tuneSettings?.sharpnessRadius, forKey: kCIInputRadiusKey)
		return sharpFilter.outputImage
	}

	func vignette(ciInput: CIImage?) -> CIImage? {
		guard let vignetteFilter = Filter.vignette.ciFilter else { return nil }
		vignetteFilter.setValue(ciInput, forKey: kCIInputImageKey)
		vignetteFilter.setValue(tuneSettings?.vignetteIntensity, forKey: kCIInputIntensityKey)
		vignetteFilter.setValue(tuneSettings?.vignetteRadius, forKey: kCIInputRadiusKey)

		return vignetteFilter.outputImage
	}

	private func rotateImage(ciImage: CIImage?) -> CIImage? {
		guard let filter = Filter.transform.ciFilter else { return nil }
		guard let angle = tuneSettings?.rotationAngle else { return nil }

		let transform = CGAffineTransform(rotationAngle: angle)

		filter.setValue(ciImage, forKey: kCIInputImageKey)
		filter.setValue(transform, forKey: kCIInputTransformKey)

		return filter.outputImage
	}

	func autoEnchance() {
		if let filters = autoEnhanceFilters {
			for filter in filters {
				filter.setValue(currentCIImage, forKey: kCIInputImageKey)
				currentCIImage = filter.outputImage
			}
		}
	}

	func appleTuneSettings() {
		guard let imageData = jpegData else { return }
		guard let inputImage = UIImage(data: imageData) else { return }

		currentCIImage = CIImage(image: inputImage)

		currentCIImage = rotateImage(ciImage: currentCIImage)
		currentCIImage = colorControls(ciInput: currentCIImage)
		currentCIImage = vignette(ciInput: currentCIImage)
		currentCIImage = sharpness(ciInput: currentCIImage)

		if let photoFilterOutput = photoFilter(ciInput: currentCIImage) {
			currentCIImage = photoFilterOutput
		}

		if self.tuneSettings?.autoEnchancement == true {
			autoEnchance()
		}

		guard let ciOuput = self.currentCIImage else { return }

		self.throttler.throttle {
			DispatchQueue.global(qos: .userInteractive).async {
				guard let cgImage = self.context.createCGImage(ciOuput, from: ciOuput.extent) else { return }
				DispatchQueue.main.async {
					self.tunedImage = UIImage(cgImage: cgImage)
				}
			}
		}
	}
}
// MARK: - IImageProcessor Methods
extension ImageProcessor: IImageProcessor
{
	func clearContexCache() {
		context.clearCaches()
	}

	func makeFullSizeTunedImage(_ image: @escaping (UIImage?) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async {
			self.outputSource?.getOriginal { original in
				if let inputImage = original {
					var ciImage = CIImage(image: inputImage)

					ciImage = self.colorControls(ciInput: ciImage)
					ciImage = self.rotateImage(ciImage: ciImage)
					ciImage = self.vignette(ciInput: ciImage)
					ciImage = self.sharpness(ciInput: ciImage)

					if let photoFilterOutput = self.photoFilter(ciInput: ciImage) {
						ciImage = photoFilterOutput
					}

					if self.tuneSettings?.autoEnchancement == true {
						self.autoEnchance()
					}

					guard let ciOuput = ciImage else { return }
					guard let cgImage = self.context.createCGImage(ciOuput, from: ciOuput.extent) else { return }
					self.clearContexCache()
					image(UIImage(cgImage: cgImage))
				}
			}
		}
}

	func filtersPreviews(image: UIImage) -> [(title: String, image: UIImage?)] {
		var previews = [(title: String, image: UIImage?)]()
		for index in 0..<Filter.photoFilters.count {
			let preview = Filter.photoFilters[index]
			let image = filteredImageForPreview(image: image, with: preview.ciFilter)
			previews.append((preview.title, image))
		}
		return previews
	}
}
