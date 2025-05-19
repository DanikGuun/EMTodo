
import UIKit

class TaskListTableContentView: UIView, UIContentView, UIContextMenuInteractionDelegate {

    var configuration: any UIContentConfiguration { didSet { updateConfiguration() } }
    
    private var isDoneView = CheckmarkView()
    private var labelsBackgroundView = UIView()
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var dateLabel = UILabel()
    
    convenience init(configuration: any UIContentConfiguration) {
        self.init(frame: .zero)
        self.configuration = configuration
    }
    
    override init(frame: CGRect) {
        self.configuration = TaskListTableContentConfiguration()
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateConfiguration() {
        let conf = getConfiguration()
        titleLabel.text = conf.title
        descriptionLabel.text = conf.taskDescription
        dateLabel.text = conf.subtitle
        isDoneView.isSelected = conf.isDone
    }
    
    private func setup() {
        setupIsDoneButton()
        setupLabelsBackgroundView()
        setupTitleLabel()
        setupDateLabel()
        setupDescriptionLabel()
    }
    
    private func setupIsDoneButton() {
        addSubview(isDoneView)
        isDoneView.translatesAutoresizingMaskIntoConstraints = false
        isDoneView.snp.makeConstraints { [weak self] maker in
            guard let self else { return }
            maker.top.leading.equalToSuperview().inset(DC.innerCellSpace)
            maker.height.equalToSuperview().dividedBy(4)
            maker.width.equalTo(self.isDoneView.snp.height)
        }
    }
    
    private func setupLabelsBackgroundView() {
        addSubview(labelsBackgroundView)
        labelsBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        labelsBackgroundView.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.bottom.trailing.equalToSuperview().inset(DC.innerCellContentSpace)
            maker.leading.equalTo(self.isDoneView.snp.trailing).offset(DC.innerCellContentSpace)
        }
        
        let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
        labelsBackgroundView.addInteraction(contextMenuInteraction)
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let conf = UIContextMenuConfiguration(actionProvider: { _ in
            let act = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), handler: { _ in })
            act.attributes = UIMenuElement.Attributes.destructive
            let menu = UIMenu(children: [act])
            return menu
        })
        return conf
    }
    
    private func setupTitleLabel() {
        labelsBackgroundView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.snp.makeConstraints { maker in
            maker.leading.top.trailing.equalToSuperview().inset(DC.innerCellSpace)
        }
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.snp.contentHuggingVerticalPriority = 1000
        titleLabel.numberOfLines = 1
    }
    
    private func setupDescriptionLabel () {
        labelsBackgroundView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.snp.makeConstraints { [weak self] maker in
            guard let self else { return }
            maker.leading.trailing.equalToSuperview().inset(DC.innerCellSpace)
            maker.top.equalTo(self.titleLabel.snp.bottom).priority(.medium)
            maker.bottom.equalTo(self.dateLabel.snp.top).priority(.medium)
        }
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.contentMode = .center
    }
    
    private func setupDateLabel() {
        labelsBackgroundView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview().inset(DC.innerCellSpace)
        }
        dateLabel.snp.contentHuggingVerticalPriority = 1000
        dateLabel.numberOfLines = 1
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .secondaryLabel
    }
    
    private func getConfiguration() -> TaskListTableContentConfiguration {
        if let conf = configuration as? TaskListTableContentConfiguration { return conf }
        return TaskListTableContentConfiguration()
    }
}
