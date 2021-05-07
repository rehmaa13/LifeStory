

import UIKit

// Photo selection cell
class A4WPhotoGalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageCheckmark: UIImageView!
    @IBOutlet weak var imageView: UIImageView!

    func setSelected(_ selected: Bool) {
        imageView.alpha = selected ? 0.5 : 1.0
        imageCheckmark.isHidden = !selected
    }
}

/// This will show/hide a loading view
class LoadingView {
    /// Static function to present a loading/spinner view when purchasing is in progress
    static func showLoadingView() {
        removeLoadingView()
        let mainView = UIView(frame: UIScreen.main.bounds)
        mainView.backgroundColor = .clear
        let darkView = UIView(frame: mainView.frame)
        darkView.backgroundColor = UIColor.black
        darkView.alpha = 0.7
        mainView.addSubview(darkView)
        let spinnerView = UIActivityIndicatorView(style: .medium)
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(spinnerView)
        spinnerView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        spinnerView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        spinnerView.startAnimating()
        mainView.tag = 1991
        DispatchQueue.main.async {
            UIApplication.shared.windows.first?.addSubview(mainView)
        }
    }
    
    /// Static function to remove the loading/spinner view
    static func removeLoadingView() {
        DispatchQueue.main.async {
            UIApplication.shared.windows.first?.viewWithTag(1991)?.removeFromSuperview()
        }
    }
}

extension UIViewController {
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
