
import UIKit

class TaskEditingViewController: UIViewController, Coordinatable, UITextFieldDelegate{
    
    var coordinator: (any Coordinator)?
    var model: TaskEditingModel
    var initialTask: TodoTask?
    
    var titleTextField = UITextField()
    var datePickerButton = UIButton()
    var descriptionTextView = UITextView()
    private var currentDate = Date() { didSet { setDateButtonText(currentDate) } }
    
    init(model: TaskEditingModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadInitialValues()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let task = getCurrentTodoTask()
        model.perform(task: task)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.becomeFirstResponder()
    }
    
    private func setup() {
        view.backgroundColor = .systemBackground
        setupTitleTextField()
        setupDatePickerButton()
        setupDescriptionTextView()
        currentDate = Date()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - Title textfield
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
        titleTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionTextView.becomeFirstResponder()
        return true
    }
    
    //MARK: DatePicker button
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
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .caption1),
            .underlineColor: UIColor.secondaryLabel.cgColor,
            .foregroundColor: UIColor.secondaryLabel.cgColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedTitle = NSAttributedString(string: text, attributes: attributes)
        
        var conf = datePickerButton.configuration
        conf?.attributedTitle = AttributedString(attributedTitle)
        datePickerButton.configuration = conf
    }
    
    //MARK: - Description textview
    private func setupDescriptionTextView() {
        view.addSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.datePickerButton.snp.bottom).offset(DC.interItemSpace)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(-50).priority(.medium)
        }
        
        descriptionTextView.isEditable = true
        descriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionTextView.contentInset = UIEdgeInsets(top: 4, left: DC.edgeInset, bottom: 0, right: DC.edgeInset)
    }
    
    //MARK: - Other
    private func loadInitialValues() {
        model.loadInitialTask { [weak self] task in
            self?.initialTask = task
            self?.titleTextField.text = task.title
            self?.descriptionTextView.text = task.taskDescription
            self?.currentDate = task.date
        }
    }
    
    private func getCurrentTodoTask() -> TodoTask {
        var task = TodoTask()
        task.id = initialTask?.id ?? UUID()
        task.title = titleTextField.text ?? ""
        task.taskDescription = descriptionTextView.text ?? ""
        task.isDone = initialTask?.isDone ?? false
        task.date = currentDate
        return task
    }
    
}
