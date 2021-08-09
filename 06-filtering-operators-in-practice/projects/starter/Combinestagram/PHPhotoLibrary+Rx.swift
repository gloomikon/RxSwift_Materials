import Foundation
import Photos
import RxSwift

extension PHPhotoLibrary {
    static var authorized: Observable<Bool> {
        return Observable.create { observer in
            DispatchQueue.main.async {
                if authorizationStatus() == .authorized {
                    observer.onNext(true)
                    observer.onCompleted()
                }
                else {
                    observer.onNext(false)
                    requestAuthorization { status in
                        observer.onNext(status == .authorized)
                        observer.onCompleted()
                    }
                }
            }
            
            return Disposables.create()
        }
    }
}
