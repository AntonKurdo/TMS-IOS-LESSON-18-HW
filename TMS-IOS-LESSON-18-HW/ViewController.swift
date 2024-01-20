import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let screenSize = UIScreen.main.bounds
    
    let scrollView = UIScrollView()
    
    let label = {
        let label = UILabel()
        label.text = ""
        label.backgroundColor = .systemCyan
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    
    var labelValue = "" {
        didSet {
            if(labelValue.count > 0) {
                self.button.isEnabled = true
                self.button.backgroundColor = .systemCyan
            } else {
                self.button.isEnabled = false
                self.button.backgroundColor = .gray
            }
        }
    }
    
    let textField = {
        let textField = UITextField()
        textField.placeholder = "Enter text..."
        textField.layer.borderColor = UIColor.systemCyan.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField.frame.size.height))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    let button = {
        let btn = UIButton()
        btn.isEnabled = false
        btn.setTitle("Done", for: .normal)
        btn.backgroundColor = btn.isEnabled ? .systemCyan : .gray
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
        
        setupScrollView()
        setupLabel()
        setupTextField()
        setupButton()
    }
    
    
    
    @objc
    private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        if notification.name == UIResponder.keyboardWillShowNotification {
            scrollView.contentOffset = CGPoint(x: 0, y: keyboardValue.cgRectValue.height / 2)
        }
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
    }
    
    private func setupLabel() {
        scrollView.addSubview(label)
        label.frame = CGRect(x: 16, y: screenSize.height * 0.55, width: screenSize.width - 32, height: 45)
    }
    
    private func setupTextField() {
        scrollView.addSubview(textField)
    
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            textField.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        let editingChanged = UIAction { _ in
            guard let text = self.textField.text else { return }
            self.labelValue = text
        }
        
        textField.addAction(editingChanged, for: .editingChanged)
        textField.becomeFirstResponder()
    }
    
    private func setupButton() {
        scrollView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 120),
            button.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        button.addAction(UIAction(handler: {_ in
            self.label.text = self.textField.text
            self.textField.text = ""
            self.labelValue = ""
        }), for: .touchUpInside)
    }
}

extension UIViewController:  UIGestureRecognizerDelegate {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         return !(touch.view is UIButton)
     }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
