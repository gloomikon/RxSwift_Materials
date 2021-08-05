import Foundation
import UIKit
import Photos
import RxSwift

class PhotoWriter {
    enum Errors: Error {
        case couldNotSavePhoto
    }
    
    static func save(_ image: UIImage) -> Single<String> {
        return Single.create { single in
            var savedAssetID: String?
            
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                savedAssetID = request.placeholderForCreatedAsset?.localIdentifier
            },
            completionHandler: { success, error in
                DispatchQueue.main.async {
                    if success, let id = savedAssetID {
                        single(.success(id))
                    }
                    else {
                        single(.error(error ?? Errors.couldNotSavePhoto))
                    }
                }
            })
            
            return Disposables.create()
        }
    }
}
