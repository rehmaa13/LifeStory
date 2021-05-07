
import UIKit

/// Main vault interface
class VaultViewController: UIViewController {

    @IBOutlet var emptyStateView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var bottomView: UIView!
    private var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSavedImages()
    }
    
    private func fetchSavedImages() {
        VaultImagePicker.fetchSavedImages { (data) in
            DispatchQueue.main.async {
                self.images = data
                self.collectionView.reloadData()
                self.emptyStateView.isHidden = data.count > 0
            }
        }
    }

    private func setupUserInterface() {
        bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        fetchSavedImages()
    }
    
    @IBAction func launchImagePicker(_ sender: Any) {
        VaultImagePicker.presentImagePicker(parent: self) { (images) in
            self.images.append(contentsOf: images ?? [UIImage]())
            self.images.forEach { (image) in
                VaultImagePicker.saveImage(image)
            }
            self.fetchSavedImages()
        }
    }
    
   
}

// MARK: - Shows a list of vault photos
extension VaultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? VaultItemCollectionViewCell {
            cell.configure(image: images[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let preview = storyboard?.instantiateViewController(withIdentifier: "imagePreview") as? ImagePreviewViewController {
            preview.image = images[indexPath.row]
            present(preview, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width / 2) - 30
        return CGSize(width: width, height: width * 1.15)
    }
}
