//
//  Repository.swift
//  PhotoTune
//
//  Created by MacBook Air on 17.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

protocol IRepository
{
	func getImages() -> [EditedImage]
}

final class Repository
{
	var images: [EditedImage] {
		[
			EditedImage(imagePath: "images-6.jpeg", editingDate: "12.12.2019"),
			EditedImage(imagePath: "images-2.jpeg", editingDate: "12.12.2019"),
			EditedImage(imagePath: "images-3.jpeg", editingDate: "12.12.2019"),
			EditedImage(imagePath: "images-4.jpeg", editingDate: "12.12.2019"),
			EditedImage(imagePath: "images-5.jpeg", editingDate: "12.12.2019"),
			EditedImage(imagePath: "images.jpeg", editingDate: "12.12.2019"),
			EditedImage(imagePath: "images-7.jpeg", editingDate: "12.12.2019"),
			EditedImage(imagePath: "images-8.jpeg", editingDate: "12.12.2019"),
		]
	}
}

extension Repository: IRepository
{
	func getImages() -> [EditedImage] {
		return images
	}
}
