//
//  PracticeVocabSetupViewController.swift
//  RfWK
//
//  Created by Florian Nöhring on 09.06.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit

class PracticeVocabSetupViewController: UIViewController {
    // TODO: add option to select subject levels for this session instead of defaulting to 1...user.level
    // TODO: use double ended slider for level range selection. See  https://www.raywenderlich.com/7595-how-to-make-a-custom-control-tutorial-a-reusable-slider
    
    var minimumLevel: Int!
    var maximumLevel: Int!
    var sessionLength: Int!
    var filter: PracticeSessionSettings.Filter!
    
    let layoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 16, trailing: 16)
    var defaults: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        self.view.addGestureRecognizer(tap)
        
        additionalSetup()
        setupAdditionalViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc private func dismissPicker() {
        self.selectedFilterView.resignFirstResponder()
    }
    
    private func setFilter(value: PracticeSessionSettings.Filter) {
        self.filter = value
        self.selectedFilterView.text = value.description
        defaults.set(value.rawValue, forKey: Constants.defaultsKeyForPracticeSessionSettingsFilter)
    }

    private func initializeFilter() {
        let initialFilter: PracticeSessionSettings.Filter
        if let defaultsFilterRawValue = defaults.object(forKey: Constants.defaultsKeyForPracticeSessionSettingsFilter) as? Int {
            initialFilter = PracticeSessionSettings.Filter.init(rawValue: defaultsFilterRawValue)!
        } else {
            initialFilter = .noAuxiliary
        }
        self.setFilter(value: initialFilter)
        self.pickerView.selectRow(initialFilter.rawValue, inComponent: 0, animated: true)
    }
    
    func initializeSessionLength() {
        self.sessionLength = defaults.value(forKey: Constants.defaultsKeyForPracticeSessionSettingsLength) as? Int ?? 20
        self.sessionLengthDisplay.text = String(sessionLength)
        self.sessionLengthSlider.value = Float(sessionLength)
    }
    
    private func additionalSetup() {
        let user = UserStore().retrieve()!
        
        self.minimumLevel = 1
        self.maximumLevel = user.data.level

        pickerView.dataSource = self
        pickerView.delegate = self
        
        selectedFilterView.inputView = self.pickerView
        selectedFilterView.delegate = self

        initializeFilter()
        initializeSessionLength()
    }
    
    func setupAdditionalViews() {
        view.directionalLayoutMargins = layoutMargins
        
        view.addSubview(titleLabel)
        view.addSubview(sessionLengthLabel)
        view.addSubview(sessionLengthStackView)
        sessionLengthStackView.addArrangedSubview(sessionLengthSlider)
        sessionLengthStackView.addArrangedSubview(sessionLengthDisplay)
        view.addSubview(selectedFilterWrapper)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            sessionLengthLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            sessionLengthLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 3),
            
            sessionLengthStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            sessionLengthStackView.topAnchor.constraint(equalToSystemSpacingBelow: sessionLengthLabel.bottomAnchor, multiplier: 0.5),
            sessionLengthStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            selectedFilterWrapper.topAnchor.constraint(equalToSystemSpacingBelow: sessionLengthStackView.bottomAnchor, multiplier: 2.0),
            selectedFilterWrapper.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            selectedFilterWrapper.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            selectedFilterWrapper.heightAnchor.constraint(greaterThanOrEqualToConstant: 20.0),
            
            startButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            startButton.topAnchor.constraint(equalToSystemSpacingBelow: selectedFilterWrapper.bottomAnchor, multiplier: 4.0),
        ])
    }
    
    var sessionLengthStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12.0
        return stackView
    }()
    
    var sessionLengthDisplay: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(17.0)
        label.text = "Practice session"
        return label
    }()
    
    var sessionLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Session length"
        return label
    }()
    
    var sessionLengthSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isContinuous = true
        slider.minimumValue = 5.0
        slider.maximumValue = 50.0
        slider.value = 15
        slider.addTarget(self, action: #selector(changeSessionLength(sender:)), for: .valueChanged)
        return slider
    }()
    
    var filterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let explainFilterLink: UIButton = {
        let link = UIButton()
        link.translatesAutoresizingMaskIntoConstraints = false
        link.setTitle("What is this?", for: .normal)
        link.setTitleColor(.black, for: .normal)
        link.titleLabel?.font = Constants.font(font: .system, size: .tiny)
        if #available(iOS 13, *) {
            link.setTitleColor(.link, for: .normal)
        } else {
            link.setTitleColor(link.tintColor, for: .normal)
        }
        link.addTarget(self, action: #selector(explainFilter), for: .touchUpInside)
        return link
    }()
    
    lazy var selectedFilterWrapper: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Label
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Translation filter"
        view.addSubview(label)
        
        // Textfield
        view.addSubview(selectedFilterView)
        
        // Link
        view.addSubview(explainFilterLink)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            selectedFilterView.topAnchor.constraint(equalToSystemSpacingBelow: label.bottomAnchor, multiplier: 0.5),
            selectedFilterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectedFilterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            explainFilterLink.topAnchor.constraint(equalTo: selectedFilterView.bottomAnchor),
            explainFilterLink.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            explainFilterLink.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return view
    }()
    
    @IBAction private func explainFilter(sender: Any?) {
        self.dismissPicker()
        self.performSegue(withIdentifier: "ExplainPracticeSessonSettingsFilter", sender: sender)
    }
    
    var selectedFilterView: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.textAlignment = .center
        textfield.placeholder = "Select filter"
        textfield.selectedTextRange = nil
        textfield.tintColor = .clear
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    @IBAction func changeSessionLength(sender: UISlider) {
        let length = Int(sender.value)
        defaults.set(length, forKey: Constants.defaultsKeyForPracticeSessionSettingsLength)
        self.sessionLength = length
        sessionLengthDisplay.text = String(length)
    }
    
    var startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        
        if #available(iOS 13, *) {
            button.setTitleColor(.link, for: .normal)
        } else {
            button.setTitleColor(button.tintColor, for: .normal)
        }
        button.addTarget(self, action: #selector(start(sender:)), for: .touchUpInside)
        return button
    }()
    
    @IBAction func start(sender: UIButton) {
        performSegue(withIdentifier: "toPracticeVocabSession", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PracticeVocabSessionViewController {
            destination.practiceVocabSetupVC = self
            destination.settings = PracticeSessionSettings(minimumLevel: minimumLevel,
                                                           maximumLevel: maximumLevel,
                                                           sessionLength: sessionLength,
                                                           filter: self.filter)
        } else if sender as? UIButton == explainFilterLink {
            let viewController = segue.destination as! RichTextViewController
            viewController.url = Bundle.main.url(forResource: "Translation_filter", withExtension: "rtf")
        }
    }
}

extension PracticeVocabSetupViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        PracticeSessionSettings.Filter.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let selectedFilter = PracticeSessionSettings.Filter.init(rawValue: row)!
        return selectedFilter.description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedFilter = PracticeSessionSettings.Filter.init(rawValue: row)!
        self.setFilter(value: selectedFilter)
    }
}

extension PracticeVocabSetupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false // Return false to prevent typing with external keyboard. The text field uses a picker view instead.
    }
}
