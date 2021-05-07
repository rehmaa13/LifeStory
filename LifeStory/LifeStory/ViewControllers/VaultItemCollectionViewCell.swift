

import UIKit

/// Shows a saved photo item
class VaultItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var templateImageView: UIImageView!
    
    func configure(image: UIImage) {
        templateImageView.image = image
    }
}
