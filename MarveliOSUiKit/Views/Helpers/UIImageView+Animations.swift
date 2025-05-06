import UIKit

extension UIImageView {
	func setImageAnimated(_ newImage: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.image = newImage
        }

		guard newImage != nil else { return }

        DispatchQueue.main.async { [weak self] in
            self?.alpha = 0
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.alpha = 1
            }
        }
	}
}
