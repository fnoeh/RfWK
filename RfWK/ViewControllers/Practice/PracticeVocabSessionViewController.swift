//
//  PractiveVocabSessionViewController.swift
//  RfWK
//
//  Created by Florian Nöhring on 09.06.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit
import CoreData

struct PracticeSessionSettings {
    
    enum Filter: Int {
        /* Consider 二人 (meaning two people) as Example.
         *   - Only primary meaning is "Two people"
         *   - Additional non-primary meanings include "Couple", "Pair", "Two persons"
         *   - Auxiliary meanings also include: "2 People", "2 Persons"
         *
         *  User synonyms are never included in the API. Reference 数年.
         */
        
        case onlyPrimary   = 0 // primary = 1 (will also exclude all auxiliary)
        case noAuxiliary   = 1 // auxiliary = 0
        case all           = 2 // primary = 0/1, auxiliary = 0/1
        case noPrimary     = 3 // primary = 0
        case onlyAuxiliary = 4 // auxiliary = 1
        
        static var count: Int {
            return 5
        }
        
        func predicateFilter() -> String {
            switch self {
            case .onlyPrimary:
                return "self.primary = 1"
            case .noAuxiliary:
                return "self.auxiliary = 0"
            case .all:
                return ""
            case .noPrimary:
                return "self.primary = 0"
            case .onlyAuxiliary:
                return "self.auxiliary = 1"
            }
        }
        
        var description: String {
            switch self {
            case .onlyPrimary:
                return "Only Primary"
            case .noAuxiliary:
                return "No Auxiliary"
            case .all:
                return "All"
            case .noPrimary:
                return "No Primary"
            case .onlyAuxiliary:
                return "Only Auxiliary"
            }
        }
    }
    
    var minimumLevel: Int
    var maximumLevel: Int
    var sessionLength: Int
    var filter: PracticeSessionSettings.Filter
}

struct SessionRecord {
    var completedTranslationIDs: [NSManagedObjectID] = []
    var completedTranslationReviews: [TranslationReview] = []
}

enum CurrentStep {
    case giveAnswer
    case showResult
}

class PracticeVocabSessionViewController: UIViewController {

    var practiceVocabSetupVC: UIViewController!
    var currentStep: CurrentStep = .giveAnswer
    var settings: PracticeSessionSettings!
    var counter = 0
    var subjectTranslationHandler: SubjectTranslationHandler<SubjectTranslation>!
    
    var completedTranslationIDs = Set<Translation>()
    
    var sessionRecord = SessionRecord()
    var currentReview: TranslationReview?
    
    var context: NSManagedObjectContext = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }()
    
    private func filterPredicateForRandomSelection() -> NSPredicate {
        var format = "self.subject.object = %@ AND NOT (self.translation IN %@)"
        if settings.filter != .all {
            format += " AND \(settings.filter.predicateFilter())"
        }
        return NSPredicate.init(format: format, "vocabulary", self.completedTranslationIDs)
    }
    
    private func selectNextRandomSubjectTranslation() -> TranslationReview? {
        do {
            if let subjectTranslation = try subjectTranslationHandler.random(predicate: filterPredicateForRandomSelection()) {
                let review = try TranslationReview.init(translation: subjectTranslation.translation!)
                
                self.completedTranslationIDs.insert(subjectTranslation.translation!)
                self.currentReview = review
                
                // print("Accepted answers for \(review.translation.meaning!): \(review.vocabularyReadings + review.vocabularyWritings)")
                return review
            } else {
                // No more available translations, End this session
                return nil
            }
        } catch {
            print("Error during selectNextRandomSubjectTranslation: \(error.localizedDescription)")
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        viewRespectsSystemMinimumLayoutMargins = false
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        subjectTranslationHandler = SubjectTranslationHandler<SubjectTranslation>(context: context)
        textField.delegate = self
        
        setupViews()
        
        if let review = selectNextRandomSubjectTranslation() {
            present(translationReview: review)
        }
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setupViews() {
        self.view.layoutMargins = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        let marginsForTranslationAndAnswer = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        
        self.view.addSubview(stackView)
        
        stackView.addArrangedSubview(translationView)
        stackView.addArrangedSubview(givenAnswerView)
        stackView.addArrangedSubview(acceptedAnswersView)
        stackView.addArrangedSubview(resultView)
        stackView.addArrangedSubview(textFieldWrapper)
        stackView.addArrangedSubview(buttonsWrapper)
        
        translationView.addSubview(translationLabel)
        translationView.addSubview(counterLabel)
        translationView.layoutMargins = marginsForTranslationAndAnswer
        
        givenAnswerView.addSubview(givenAnswerLabel)
        givenAnswerView.layoutMargins = marginsForTranslationAndAnswer
        
        acceptedAnswersView.addSubview(acceptedWritingsLabel)
        acceptedAnswersView.addSubview(acceptedReadingsLabel)
        acceptedAnswersView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        textFieldWrapper.addSubview(textField)
        textFieldWrapper.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 2, right: 16)
        
        buttonsWrapper.addSubview(endButton)
        buttonsWrapper.addSubview(submitButton)
        buttonsWrapper.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        resultView.addSubview(resultLabel)
        resultLabel.layoutMargins = UIEdgeInsets(top: 7.0, left: 4.0, bottom: 4.0, right: 4.0)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            
            translationView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            translationView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

            translationLabel.leadingAnchor.constraint(equalTo: translationView.layoutMarginsGuide.leadingAnchor),
            translationLabel.topAnchor.constraint(equalTo: translationView.layoutMarginsGuide.topAnchor),
            translationLabel.trailingAnchor.constraint(equalTo: translationView.layoutMarginsGuide.trailingAnchor),
            translationLabel.bottomAnchor.constraint(equalTo: translationView.layoutMarginsGuide.bottomAnchor),

            counterLabel.trailingAnchor.constraint(equalTo: translationView.trailingAnchor, constant: -4),
            counterLabel.topAnchor.constraint(equalTo: translationView.topAnchor, constant: 4),
            
            givenAnswerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            givenAnswerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

            givenAnswerLabel.topAnchor.constraint(equalTo: givenAnswerView.layoutMarginsGuide.topAnchor),
            givenAnswerLabel.bottomAnchor.constraint(equalTo: givenAnswerView.layoutMarginsGuide.bottomAnchor),
            givenAnswerLabel.leadingAnchor.constraint(equalTo: givenAnswerView.layoutMarginsGuide.leadingAnchor),
            givenAnswerLabel.trailingAnchor.constraint(equalTo: givenAnswerView.layoutMarginsGuide.trailingAnchor),

            acceptedAnswersView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            acceptedAnswersView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            acceptedWritingsLabel.topAnchor.constraint(equalTo: acceptedAnswersView.layoutMarginsGuide.topAnchor),
            acceptedWritingsLabel.leadingAnchor.constraint(equalTo: acceptedAnswersView.layoutMarginsGuide.leadingAnchor),
            acceptedWritingsLabel.trailingAnchor.constraint(equalTo: acceptedAnswersView.layoutMarginsGuide.trailingAnchor),
            
            acceptedReadingsLabel.topAnchor.constraint(equalTo: acceptedWritingsLabel.bottomAnchor),
            acceptedReadingsLabel.leadingAnchor.constraint(equalTo: acceptedAnswersView.layoutMarginsGuide.leadingAnchor),
            acceptedReadingsLabel.trailingAnchor.constraint(equalTo: acceptedAnswersView.layoutMarginsGuide.trailingAnchor),
            acceptedReadingsLabel.bottomAnchor.constraint(equalTo: acceptedAnswersView.layoutMarginsGuide.bottomAnchor),
            
            resultView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            resultView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            resultLabel.leadingAnchor.constraint(equalTo: resultView.layoutMarginsGuide.leadingAnchor),
            resultLabel.topAnchor.constraint(equalTo: resultView.layoutMarginsGuide.topAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: resultView.layoutMarginsGuide.trailingAnchor),
            resultLabel.bottomAnchor.constraint(equalTo: resultView.layoutMarginsGuide.bottomAnchor),
            
            textFieldWrapper.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            textFieldWrapper.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: textFieldWrapper.layoutMarginsGuide.topAnchor),
            textField.bottomAnchor.constraint(equalTo: textFieldWrapper.layoutMarginsGuide.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: textFieldWrapper.layoutMarginsGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: textFieldWrapper.layoutMarginsGuide.trailingAnchor),
            
            buttonsWrapper.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            buttonsWrapper.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            endButton.leadingAnchor.constraint(equalTo: buttonsWrapper.layoutMarginsGuide.leadingAnchor),
            endButton.topAnchor.constraint(equalTo: buttonsWrapper.layoutMarginsGuide.topAnchor),
            
            submitButton.trailingAnchor.constraint(equalTo: buttonsWrapper.layoutMarginsGuide.trailingAnchor),
            submitButton.topAnchor.constraint(equalTo: buttonsWrapper.layoutMarginsGuide.topAnchor),
        ])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PracticeVocabSessionResultsViewController {
            destination.practiceVocabSetupVC = self.practiceVocabSetupVC
            destination.reviews = self.sessionRecord.completedTranslationReviews
        }
    }
    
    @IBAction func endAction(sender: Any?) {
        self.performSegue(withIdentifier: "toPracticeVocabSessionResults", sender: self)
    }
    
    @IBAction func submitAction(sender: Any?) {
        switch currentStep {
        	case .giveAnswer:
                if counter == settings.sessionLength {
                    submitButton.setTitle("End", for: .normal)
                    endButton.isHidden = true
                } else {
                    submitButton.setTitle("Next", for: .normal)
                }
                
                self.currentStep = .showResult
                let answer = (textField.text! != "") ? givenAnswerLabel.text! : ""
                textField.text = ""
                checkAnswer(answer: answer)
            case .showResult:
                resetGivenAnswer()
                resultView.isHidden = true
                
                if counter == settings.sessionLength {
                    self.endAction(sender: self)
                } else if let nextReview = selectNextRandomSubjectTranslation() {
                    present(translationReview: nextReview)
                } else {
                    self.endAction(sender: self)
                }
        }
    }

    func present(translationReview: TranslationReview) {
        self.counter += 1
        self.currentStep = .giveAnswer
        translationLabel.text = translationReview.translation.meaning!
        counterLabel.text = "\(String(self.counter)) / \(String(self.settings.sessionLength))"
        translationView.backgroundColor = UIColor(named: "Review.Neutral")
        submitButton.setTitle("Skip", for: .normal)
        textFieldWrapper.isHidden = false
        acceptedAnswersView.isHidden = true
        acceptedWritingsLabel.text = translationReview.vocabularyWritings.joined(separator: ", ")
        acceptedReadingsLabel.text = translationReview.vocabularyReadings.joined(separator: ", ")
        
        self.resetGivenAnswer()
        self.view.setNeedsLayout()
    }
    
    func checkAnswer(answer: String) {
        if let review = currentReview {
            let result = review.checkAnswer(answer: answer)
            showResult(result: result, answer: answer)
            
            sessionRecord.completedTranslationReviews.append(review)
            currentReview = nil
        }
    }
    
    
    func showResult(result: TranslationReviewResult, answer: String) {
        switch result {
        	case .correct:
                givenAnswerLabel.font =  Constants.font(font: .japaneseSerif, size: .japaneseTableContent)
                givenAnswerLabel.attributedText = NSAttributedString(string: answer)
                translationView.backgroundColor = UIColor(named: "Review.Correct")
                givenAnswerView.backgroundColor = UIColor(named: "Review.Correct")
                resultLabel.text = "correct"
            case .wrong:
                givenAnswerLabel.font =  Constants.font(font: .japaneseSerif, size: .japaneseTableContent)
                givenAnswerLabel.attributedText = NSAttributedString(string: answer,
                                                                     attributes: [NSAttributedString.Key.strikethroughStyle : 3])
                translationView.backgroundColor = UIColor(named: "Review.Wrong")
                givenAnswerView.backgroundColor = UIColor(named: "Review.Wrong")
                resultLabel.text = "wrong"
            case .skipped:
                givenAnswerLabel.font = UIFont.italicSystemFont(ofSize: givenAnswerLabel.font.pointSize)
                givenAnswerLabel.attributedText = NSAttributedString(string: "no answer given")
                translationView.backgroundColor = UIColor(named: "Review.Wrong")
                givenAnswerView.backgroundColor = UIColor(named: "Review.Wrong")
                resultLabel.text = "skipped"
        }
        
        givenAnswerLabel.textColor = .white
        acceptedAnswersView.isHidden = false
        resultView.isHidden = false
        textFieldWrapper.isHidden = true
    }
    
    var endButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(endAction(sender:)), for: .touchUpInside)
        button.setTitle("End", for: .normal)
        button.setTitleColor(button.tintColor, for: .normal)
        return button
    }()
    
    var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitAction(sender:)), for: .touchUpInside)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(button.tintColor, for: .normal)
        return button
    }()
    
    var textFieldWrapper: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var translationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var translationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.init(name: "ChalkboardSE-Regular", size: 20.0)
        label.textColor = .white
        return label
    }()
    
    var counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(13.0)
        label.textColor = .white
        return label
    }()
    
    var givenAnswerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        return view
    }()
    
    var givenAnswerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.addConstraint(label.heightAnchor.constraint(greaterThanOrEqualToConstant: 28))
        return label
    }()
    
    var resultView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.isHidden = true // Result is not shown initially
        return view
    }()
    
    var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.init(name: "ChalkboardSE-Regular", size: 20.0)
        label.text = "correct"
        return label
    }()
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13, *) {
            textField.textColor = .label
        } else {
            textField.textColor = .black
        }
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.clearButtonMode = .always
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        textField.placeholder = "Reading or writing in Romaji/Kana/Kanji"
        return textField
    }()
    
    var buttonsWrapper: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var acceptedAnswersView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Review.Neutral")
        view.isHidden = true // Not shown initially
        return view
    }()
    
    var acceptedWritingsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Constants.font(font: .japaneseSerif, size: .large)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var acceptedReadingsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Constants.font(font: .japaneseSerif, size: .large)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private func resetGivenAnswer() {
        givenAnswerLabel.font = Constants.font(font: .system, size: .large)
        
        if #available(iOS 13, *) {
            givenAnswerView.backgroundColor = .systemBackground
        } else {
            givenAnswerView.backgroundColor = .white
        }
        
        givenAnswerLabel.textColor = .gray
        givenAnswerLabel.attributedText = givenAnswerPlaceholderText
    }
    
    private var givenAnswerPlaceholderText: NSAttributedString = {
        return NSAttributedString(string: "Your answer", attributes: [
            NSAttributedString.Key.strikethroughStyle : 0,
            NSAttributedString.Key.obliqueness : 0.15
        ])
    }()
    
    private func presentGivenAnswer() {
        givenAnswerLabel.font = Constants.font(font: .japaneseSerif, size: .large)

        if #available(iOS 13, *) {
            givenAnswerLabel.textColor = .label
        } else {
            givenAnswerLabel.textColor = .black
        }
        
        givenAnswerLabel.attributedText = NSAttributedString(string: RomajiToKanaTransliteration(input: textField.text ?? "").output,
                                                             attributes: [
                                                                NSAttributedString.Key.strikethroughStyle : 0,
                                                                NSAttributedString.Key.obliqueness : 0.0
        ])
    }
}

extension PracticeVocabSessionViewController : UITextFieldDelegate {
    @IBAction func textFieldDidChange(sender: UITextField) {
        let submitButtonTitle = textField.text == "" ? "Skip" : "Submit"
        submitButton.setTitle(submitButtonTitle, for: .normal)
        
        sender.text == "" ? resetGivenAnswer() : presentGivenAnswer()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true;
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true;
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: prevent submitting a reading/writing of only a Kanji
        
        textField.resignFirstResponder();
        
        if textField.text != "" {
            self.submitAction(sender: textField)
        }
        return true;
    }
}
