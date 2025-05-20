
import UIKit

class DatePickerViewController: UIViewController, Coordinatable {
    var coordinator: (any Coordinator)?
    var callback: ((Date) -> Void)?
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupDatePicker()
    }
    
    private func setupDatePicker() {
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addAction(UIAction(handler: { [weak self] _ in
            self?.datePickerValueChanged()
        }), for: .valueChanged)
    }
    
    private func datePickerValueChanged() {
        let date = datePicker.date
        callback?(date)
    }
}

