

import UIKit
import Photos

/// Save and Retrieve photo items
class VaultManager: NSObject {

    static var passcode: String?
    
    static func fetchPasscode() {
        passcode = UserDefaults.standard.string(forKey: "passcode")
        if passcode == nil {
            guard let documentsUrl = filesDocumentsURL else { return }
            let fileURL = documentsUrl.appendingPathComponent("passcode.txt")
            if let data = try? Data(contentsOf: fileURL), let stringData = String(data: data, encoding: .utf8) {
                passcode = String(data: Data(base64Encoded: stringData) ?? Data(), encoding: .utf8)
            }
        }
    }
    
    static func setPasscode(_ code: String) {
        passcode = code
        UserDefaults.standard.set(code, forKey: "passcode")
        UserDefaults.standard.synchronize()
        
        guard let documentsUrl = filesDocumentsURL else { return }
        let fileURL = documentsUrl.appendingPathComponent("passcode.txt")
        try? Data(code.utf8).base64EncodedData().write(to: fileURL, options: .atomic)
    }
    
    private static var filesDocumentsURL: URL? {
        let cloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)
        return cloudURL ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
