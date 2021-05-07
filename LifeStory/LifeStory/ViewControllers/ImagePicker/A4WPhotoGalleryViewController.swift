

import UIKit
import Photos

// Photos selection gallery controller
class A4WPhotoGalleryViewController: UIViewController {
    
    @IBOutlet weak var photoAccessContainer: UIView!
    @IBOutlet weak var allowAccessButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    private var rightButton: UIBarButtonItem!
    private var images = [PHAsset]()
    private var selectedImages: [Int : UIImage?] = [:]
    var didSelectImages: ((_ images: [UIImage]?) -> Void)?
    var allowMultipleSelection: Bool = true
    var presented: Bool = false
    
    /// Initial logic when this screen loads
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo Library"
        rightButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelFlow(_:)))
        navigationItem.rightBarButtonItem = rightButton
        allowAccessButton.layer.cornerRadius = 10
        collectionView.register(UINib(nibName: "A4WPhotoGalleryCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "cell")
        checkPhotoLibraryPermission(requestAuthorization: false)
    }
    
    /// Set controller is presented when view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presented = true
        selectedImages.removeAll()
        collectionView.reloadData()
    }
    
    /// This will cancel the preview flow and notify Gallery screen to present an ad
    @objc private func cancelFlow(_ sender: UIBarButtonItem) {
        presented = false
        didSelectImages?(Array(selectedImages.values) as? [UIImage])
        dismiss(animated: true, completion: nil)
    }
    
    /// This will get the images from user's photo library and show on the screen (bottom part of preview screen)
    private func getImages() {
        let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        assets.enumerateObjects({ (object, count, stop) in self.images.append(object) })
        images.reverse()
        collectionView.reloadData()
    }
    
    /// Allow photos access
    @IBAction func allowAccessAction(_ sender: UIButton) {
        checkPhotoLibraryPermission()
    }
}

// MARK: - Show all photo gallery photos
extension A4WPhotoGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? A4WPhotoGalleryCollectionViewCell {
            let asset = images[indexPath.row]
            let manager = PHImageManager.default()
            if cell.tag != 0 { manager.cancelImageRequest(PHImageRequestID(cell.tag)) }
            cell.setSelected(selectedImages[indexPath.row] != nil)
            let imageSize = CGSize(width: view.frame.width/3 * 1.2, height: view.frame.width/3 * 1.2)
            cell.tag = Int(manager.requestImage(for: asset, targetSize: imageSize, contentMode: PHImageContentMode.default,
                                                options: nil) { (result, _) in cell.imageView.image = result })
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/3 - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if allowMultipleSelection == false {
            collectionView.visibleCells.forEach { (cell) in
                (cell as? A4WPhotoGalleryCollectionViewCell)?.setSelected(false)
            }
            selectedImages.removeAll()
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? A4WPhotoGalleryCollectionViewCell {
            /// remove any existing images if user selects it twice
            if selectedImages[indexPath.row] != nil {
                unselectImage(atIndexPath: indexPath, cell: cell)
                return
            }
            
            /// add images for selected index
            LoadingView.showLoadingView()
            let requestOptions = PHImageRequestOptions()
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.isNetworkAccessAllowed = true
            PHImageManager.default().requestImage(for: images[indexPath.row], targetSize: CGSize(width: 640, height: 640), contentMode: .aspectFill, options: requestOptions) { (image, _) in
                DispatchQueue.main.async {
                    LoadingView.removeLoadingView()
                    if let downloadedImage = image {
                        downloadedImage.accessibilityIdentifier = self.images[indexPath.row]
                            .localIdentifier.replacingOccurrences(of: "/", with: "~")
                        self.selectedImages[indexPath.row] = downloadedImage
                        self.rightButton.title = self.selectedImages.count > 0 ? "Done" : "Cancel"
                        self.title = self.selectedImages.count > 0 ? "\(self.selectedImages.count) Photo Selected" : "Photo Library"
                        cell.setSelected(true)
                    } else {
                        self.unselectImage(atIndexPath: indexPath, cell: cell)
                        self.presentAlert(title: "Couldn't select photo", message: "Error downloading image from iCloud")
                    }
                }
            }
        }
    }
    
    private func unselectImage(atIndexPath indexPath: IndexPath, cell: A4WPhotoGalleryCollectionViewCell) {
        selectedImages.removeValue(forKey: indexPath.row)
        rightButton.title = self.selectedImages.count > 0 ? "Done" : "Cancel"
        cell.setSelected(false)
        title = selectedImages.count > 0 ? "\(selectedImages.count) Photo Selected" : "Photo Library"
    }
}

// MARK: - Extension to handle the photo library access/permission
extension A4WPhotoGalleryViewController {
    func checkPhotoLibraryPermission(requestAuthorization: Bool = true) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            //handle authorized status
            photoAccessContainer.isHidden = true
            getImages()
        case .denied, .restricted :
            //handle denied status
            photoAccessContainer.isHidden = false
        case .notDetermined:
            // ask for permissions
            guard requestAuthorization else { return }
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.photoAccessContainer.isHidden = true
                        self.getImages()
                    }
                case .denied, .restricted, .notDetermined:
                    DispatchQueue.main.async {
                        self.photoAccessContainer.isHidden = false
                    }
                default: break
                }
            }
        default: break
        }
    }
}

// MARK: - Embed controller in navigation controller
extension UIViewController {
    var embedded: UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        return navigationController
    }
}
