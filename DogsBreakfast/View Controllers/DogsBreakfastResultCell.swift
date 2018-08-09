//
//  DogsBreakfastResultCell.swift
//  DogsBreakfast
//
//  Created by Aaron Vegh on 2018-08-08.
//  Copyright © 2018 Aaron Vegh. All rights reserved.
//

import UIKit

class DogsBreakfastResultCell: UITableViewCell {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    
    static let identifier = String(describing: DogsBreakfastResultCell.self)
    
    func configure(with recipe: Recipe) {
        recipeTitleLabel.text = recipe.title ?? ""
        var resolvedThumb = ""
        if let thumb = recipe.thumbnail, thumb != "" {
            resolvedThumb = thumb
        } else {
            resolvedThumb = "http://img.recipepuppy.com/9.jpg" // The API's generic image; I'd normally hold this as a local asset
        }
        recipeImageView.imageFromServerURL(urlString: resolvedThumb)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImageView.image = nil
        recipeTitleLabel.text = ""
    }
}
