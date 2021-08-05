import UIKit
import RxSwift
import RxRelay

class MainViewController: UIViewController {
    
    @IBOutlet private var imagePreview: UIImageView!
    @IBOutlet private var buttonClear: UIButton!
    @IBOutlet private var buttonSave: UIButton!
    @IBOutlet private var itemAdd: UIBarButtonItem!
    
    private let bag = DisposeBag()
    private let images = BehaviorRelay<[UIImage]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images
            .subscribe(onNext: { [weak imagePreview] photos in
                guard let imagePreview = imagePreview else {
                    return
                }
                
                imagePreview.image = photos.collage(size: imagePreview.frame.size)
            })
            .disposed(by: bag)
        
        images
            .subscribe(onNext: { [weak self] photos in
                self?.updateUI(photos: photos)
            })
            .disposed(by: bag)
    }
    
    @IBAction func actionClear() {
        images.accept([])
    }
    
    @IBAction func actionSave() {
        guard let image = imagePreview.image else {
            return
        }
        
        PhotoWriter.save(image)
            .subscribe(
                onSuccess: { [weak self] id in
                    guard let self = self else {
                        return
                    }
                    
                    self.showMessage("Saved with id: \(id)")
                    self.actionClear()
                },
                onError: { [weak self] error in
                    self?.showMessage("Error", description: error.localizedDescription)
                })
            .disposed(by: bag)
    }
    
    @IBAction func actionAdd() {
//        let newImages = images.value + [UIImage(named: "IMG_1907.jpg")!]
//        images.accept(newImages)
        let photosViewController = storyboard!.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
        
        photosViewController.selectedPhotos
            .subscribe(
                onNext: { [weak self] image in
                    guard let images = self?.images else {
                        return
                    }
                    let newImages = images.value + [image]
                    images.accept(newImages)
                },
                onDisposed: {
                    print("Completed photos selection")
                }
            )
            .disposed(by: bag)
        
        navigationController!.pushViewController(photosViewController, animated: true)
    }
    
    func showMessage(_ title: String, description: String? = nil) {
      alert(title: title, description: description)
        .subscribe()
        .disposed(by: bag)
    }
    
    private func updateUI(photos: [UIImage]) {
        buttonSave.isEnabled = photos.count > 0 && photos.count % 2 == 0
        buttonClear.isEnabled = photos.count > 0
        itemAdd.isEnabled = photos.count < 6
        title = photos.count > 0 ? "\(photos.count) photos" : "Collage"
    }
}
