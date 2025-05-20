
import UIKit

class TaskEditingViewController: UIViewController, Coordinatable {
    
    var coordinator: (any Coordinator)?
    var titleTextField = UITextField()
    var datePickerButton = UIButton()
    var descriptionTextView = UITextView()
    private var currentDate = Date() { didSet { setDateButtonText(currentDate) } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .systemBackground
        setupTitleTextField()
        setupDatePickerButton()
        setupDescriptionTextView()
        setDateButtonText("02/10/24")
    }
    
    private func setupTitleTextField() {
        view.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.snp.makeConstraints { [weak self] maker in
            guard let self else { return }
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.leading.trailing.equalToSuperview().inset(DC.edgeInset)
        }
        
        titleTextField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleTextField.placeholder = "Название..."
    }
    
    private func setupDatePickerButton() {
        view.addSubview(datePickerButton)
        datePickerButton.translatesAutoresizingMaskIntoConstraints = false
        datePickerButton.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.titleTextField.snp.bottom).offset(DC.interItemSpace)
            maker.leading.equalToSuperview().inset(DC.edgeInset)
            maker.trailing.equalToSuperview().inset(DC.edgeInset).priority(.medium)
        }
        datePickerButton.snp.contentHuggingHorizontalPriority = 1000
        
        var conf = UIButton.Configuration.plain()
        conf.baseBackgroundColor = .clear
        conf.baseForegroundColor = .secondaryLabel
        conf.contentInsets = .zero
        datePickerButton.configuration = conf
        datePickerButton.addAction(UIAction(handler: presentDatePicker), for: .touchUpInside)
    }
    
    private func presentDatePicker(_ action: UIAction?) {
        coordinator?.presentDatePickerViewController(startDate: currentDate, callback: dateHasUpdated, sourceView: datePickerButton, animated: true)
    }
    
    private func dateHasUpdated(_ date: Date ) {
        currentDate = date
    }
    
    private func setDateButtonText(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date)
        setDateButtonText(dateString)
    }
    
    private func setDateButtonText(_ text: String) {
        var attributedTitle = AttributedString(text)
        attributedTitle.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        var conf = datePickerButton.configuration
        conf?.attributedTitle = attributedTitle
        datePickerButton.configuration = conf
    }
    
    private func setupDescriptionTextView() {
        view.addSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.datePickerButton.snp.bottom).offset(DC.interItemSpace)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
        }
        
        descriptionTextView.isEditable = true
        descriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionTextView.contentInset = UIEdgeInsets(top: 4, left: DC.edgeInset, bottom: 0, right: DC.edgeInset)
        
    }
}
