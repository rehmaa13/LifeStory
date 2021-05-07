

import UIKit

/// Preview image in full screen and delete from photos library
class ImagePreviewViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    private var imageView: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }
    
    private func setupScrollView() {
        imageView = UIImageView(image: image)
        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(imageView)
        
        let zoomScale = min(scrollView.bounds.size.width / image.size.width, scrollView.bounds.size.height / image.size.height)
        
        let scaleX = scrollView.frame.size.width / image.size.width
        let scaleY = scrollView.frame.size.height / image.size.height
        let defaultZoomScale = scaleX < scaleY ? scaleY : scaleX
        
        scrollView.minimumZoomScale = zoomScale
        scrollView.maximumZoomScale = 10
        scrollView.zoomScale = defaultZoomScale
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Image", message: "Would you like to delete this image?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete From Photos Library", style: .destructive, handler: { (_) in
            VaultImagePicker.deleteImage(self.image, fromPhotos: true)
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Delete From Moments", style: .destructive, handler: { (_) in
            VaultImagePicker.deleteImage(self.image)
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func exitPreviewFlow(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Handle image zoom in/out
extension ImagePreviewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    private var scrollViewVisibleSize: CGSize {
        let contentInset = scrollView.contentInset
        let scrollViewSize = scrollView.bounds.standardized.size
        let width = scrollViewSize.width - contentInset.left - contentInset.right
        let height = scrollViewSize.height - contentInset.top - contentInset.bottom
        return CGSize(width:width, height:height)
    }
    
    private var scrollViewCenter: CGPoint {
        let scrollViewSize = self.scrollViewVisibleSize
        return CGPoint(x: scrollViewSize.width / 2.0, y: scrollViewSize.height / 2.0)
    }

    private func centerScrollViewContents() {
        guard let image = imageView.image else { return }

        let imgViewSize = imageView.frame.size
        let imageSize = image.size

        var realImgSize: CGSize
        if imageSize.width / imageSize.height > imgViewSize.width / imgViewSize.height {
            realImgSize = CGSize(width: imgViewSize.width,height: imgViewSize.width / imageSize.width * imageSize.height)
        } else {
            realImgSize = CGSize(width: imgViewSize.height / imageSize.height * imageSize.width, height: imgViewSize.height)
        }

        var frame = CGRect.zero
        frame.size = realImgSize
        imageView.frame = frame

        let screenSize  = scrollView.frame.size
        let offx = screenSize.width > realImgSize.width ? (screenSize.width - realImgSize.width) / 2 : 0
        let offy = screenSize.height > realImgSize.height ? (screenSize.height - realImgSize.height) / 2 : 0
        scrollView.contentInset = UIEdgeInsets(top: offy,
                                               left: offx,
                                               bottom: offy,
                                               right: offx)

        let scrollViewSize = scrollViewVisibleSize
        var imageCenter = CGPoint(x: scrollView.contentSize.width / 2.0, y: scrollView.contentSize.height / 2.0)

        let center = scrollViewCenter

        if scrollView.contentSize.width < scrollViewSize.width {
            imageCenter.x = center.x
        }

        if scrollView.contentSize.height < scrollViewSize.height {
            imageCenter.y = center.y
        }

        imageView.center = imageCenter
    }
}
