

import UIKit
import Photos

/// Image picker for photos
class VaultImagePicker: NSObject {
    
    static func presentImagePicker(parent: UIViewController, completion: @escaping (_ images: [UIImage]?) -> Void) {
        let photoGallery = A4WPhotoGalleryViewController()
        photoGallery.didSelectImages = { images in
            completion(images)
        }
        parent.present(photoGallery.embedded, animated: true, completion: nil)
    }
    
    static func saveImage(_ image: UIImage) {
        if var ids = UserDefaults.standard.stringArray(forKey: "savedIds") {
            if !ids.contains(image.accessibilityIdentifier!) { ids.append(image.accessibilityIdentifier!) }
            UserDefaults.standard.set(ids, forKey: "savedIds")
        } else {
            UserDefaults.standard.set([image.accessibilityIdentifier!], forKey: "savedIds")
        }
        UserDefaults.standard.synchronize()
        saveImageInDocumentDirectory(image: image, fileName: image.accessibilityIdentifier!)
        saveImageIDs()
    }
    
    static func deleteImage(_ image: UIImage, fromPhotos: Bool = false) {
        if var ids = getImageIds() {
            if fromPhotos {
                PHPhotoLibrary.shared().performChanges({
                    let assets = PHAsset.fetchAssets(withLocalIdentifiers: [image.accessibilityIdentifier!], options: nil)
                    PHAssetChangeRequest.deleteAssets(assets)
                })
            } else {
                ids.removeAll(where: { $0 == image.accessibilityIdentifier })
                UserDefaults.standard.set(ids, forKey: "savedIds")
                UserDefaults.standard.synchronize()
                saveImageIDs()
                guard let documentsUrl = filesDocumentsURL else { return }
                let fileURL = documentsUrl.appendingPathComponent("\(image.accessibilityIdentifier!).jpg")
                if let _ = try? Data(contentsOf: fileURL) {
                    try? FileManager.default.removeItem(at: fileURL)
                }
            }
        }
    }
    
    static func fetchSavedImages(completion: @escaping (_ images: [UIImage]) -> Void) {
        if let ids = getImageIds() {
            var imageIds = ids.sorted()
            var images = [UIImage]()

            func fetchImage(completion: @escaping (_ images: [UIImage]) -> Void) {
                if let id = imageIds.first {
                    imageIds.removeAll(where: { $0 == id })
                    if let image = loadImageFromDocumentDirectory(fileName: id) {
                        image.accessibilityIdentifier = id
                        images.append(image)
                        fetchImage(completion: completion)
                    }
                } else { completion(images) }
            }
            
            fetchImage(completion: completion)
        } else { completion([]) }
    }
    
    private static func getImageIds() -> [String]? {
        if let ids = UserDefaults.standard.stringArray(forKey: "savedIds") {
            return ids
        }
        guard let documentsUrl = filesDocumentsURL else { return nil }
        let fileURL = documentsUrl.appendingPathComponent("savedIds.txt")
        let file = try? String(contentsOf: fileURL)
        return file?.components(separatedBy: "\n")
    }
    
    private static func saveImageInDocumentDirectory(image: UIImage, fileName: String) {
        guard let documentsUrl = filesDocumentsURL else { return }
        let fileURL = documentsUrl.appendingPathComponent("\(fileName).jpg")
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            try? imageData.write(to: fileURL, options: .atomic)
        }
    }
    
    private static func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        guard let documentsUrl = filesDocumentsURL else { return nil }
        let fileURL = documentsUrl.appendingPathComponent("\(fileName).jpg")
        let imageData = try? Data(contentsOf: fileURL)
        return UIImage(data: imageData ?? Data())
    }
    
    private static var filesDocumentsURL: URL? {
        let cloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)
        return cloudURL ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    private static func saveImageIDs() {
        guard let documentsUrl = filesDocumentsURL else { return }
        let fileURL = documentsUrl.appendingPathComponent("savedIds.txt")
        if let idsData = UserDefaults.standard.stringArray(forKey: "savedIds")?.joined(separator: "\n").data(using: .utf8) {
            try? idsData.write(to: fileURL, options: .atomic)
        }
    }
}
