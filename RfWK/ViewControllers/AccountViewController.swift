//
//  AccountViewController.swift
//  RfWK
//
//  Created by Florian Nöhring on 01.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import UIKit

import CoreData

class AccountViewController: UIViewController, RequestDelegate {

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let defaults: UserDefaults = UserDefaults.standard
    
    @IBOutlet weak var apiStatus: UILabel!
    
    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var removeUserButton: UIButton!
    
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var currentLevel: UILabel!
    @IBOutlet weak var maxLevel: UILabel!
    @IBOutlet weak var registeredField: UILabel!
    
    @IBOutlet weak var userViewWrapper: UIView!
    
    @IBOutlet weak var spaceBeforeTokenStackView: NSLayoutConstraint!
    
    var alertView: UpdateActivityView?
    var user: WKUser?
    var storeContainer: NSPersistentContainer!
    
    lazy var userStore: UserStore = {
        return UserStore()
    }()
    
    lazy var userStoreFacade: UserStoreFacade = {
        return UserStoreFacade(userStore: self.userStore)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tokenTextField.delegate = self
        tokenTextField.text = defaults.string(forKey: Constants.defaultsKeyForPersonalAccessToken)

        user = userStore.retrieve()
        showUserIfExists()
        
        apiStatus.text = ""
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        storeContainer = delegate.persistentContainer
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func submitToken(_ sender: Any) {
        dismissKeyboard()
        
        if let token = ValidPersonalAccessToken.build(tokenTextField.text ?? "") {
            storeTokenInUserDefaults(token.value)
            requestUserInformation(token.value)
        }
    }
    
    @IBAction func showRemoveUserAlert(_ sender: Any) {
        let alert = UIAlertController(
            title: "Remove User",
            message: "Do you want to delete your user token and progress from Reverse for WaniKani?\n\nThis will not affect your WaniKani account.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        alert.addAction(
            UIAlertAction(title: "Confirm", style: .destructive) { (_) in
                self.removeUser()
            }
        )
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showUserIfExists() {
        guard self.user != nil else { hideUser(); return }
        
        showUser()
    }
    
    private func showUser(_ newUser: WKUser) {
        self.user = newUser
        self.showUser()
    }
    
    func showUser() {
        DispatchQueue.main.async {
            let userdata = self.user!.data
            
            self.userViewWrapper.isHidden = false
            
            self.nameField.text = userdata.username
            self.currentLevel.text = String(userdata.level)
            self.maxLevel.text = "max \(String(userdata.subscription.max_level_granted))"
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            let registrationDate = formatter.string(from: self.user!.data.started_at)
            self.registeredField.text = registrationDate
            
            self.removeUserButton.isHidden = false
            self.tokenTextField.isEnabled = false
            
            self.spaceBeforeTokenStackView.constant = 124
        }
    }
    
    private func hideUser() {
        DispatchQueue.main.async {
            self.userViewWrapper.isHidden = true
            
            self.removeUserButton.isHidden = true
            self.tokenTextField.isEnabled = true
            
            self.spaceBeforeTokenStackView.constant = 34
        }
    }
    
    private func removeUser() {
        defaults.removeObject(forKey: Constants.defaultsKeyForPersonalAccessToken)
        self.user = nil
        userStore.remove()
        self.tokenTextField.text = ""
        self.hideUser()
        
        let entityStoreFacade = EntityStoreFacade(context: storeContainer.viewContext)
        
        do {
            try entityStoreFacade.removeAll()
        } catch {
            // TODO: alert user
            print("error during EntityStoreFacade.removeAll(): \(error.localizedDescription)")
        }
    }
    
    private func storeTokenInUserDefaults(_ token: String) {
        defaults.set(token, forKey: Constants.defaultsKeyForPersonalAccessToken)
    }
    
    private func requestUserInformation(_ token: String) {
        let request = UserRequest(token: token, delegate: self)
        self.showActivity(text: request.activity)
        request.initiate()
    }
    
    @IBAction func insertCorrectToken(_ sender: Any) {
        self.tokenTextField.text = "ED64591B-0B6A-473C-9343-A1CF9861D0C4"
    }
    
    @IBAction func insertIncorrectToken(_ sender: Any) {
        self.tokenTextField.text = "595DB927-5A37-477D-9455-B7C5E6993262"
    }
    
    // MARK: - RequestDelegate
    
    func showActivity(text: String) {
        // TODO: store Controller lazily and reuse if possible
        let activityAlertVC = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        let activityAlertView: UIView = activityAlertVC.view
        activityAlertView.subviews.forEach { $0.removeFromSuperview() }
        
        let customAlertView = UpdateActivityView()
        activityAlertVC.view.addSubview(customAlertView)
        self.alertView = customAlertView
        self.resetActivity(text: text)
        
        NSLayoutConstraint.activate([
            customAlertView.centerXAnchor.constraint(equalTo: activityAlertVC.view.centerXAnchor),
            customAlertView.centerYAnchor.constraint(equalTo: activityAlertVC.view.centerYAnchor)
        ])
        
        self.present(activityAlertVC, animated: false, completion: nil)
    }
    
    func hideActivity(message: String?) {
        DispatchQueue.main.async {
            self.apiStatus?.text = message
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func resetActivity(text: String) {
        DispatchQueue.main.async {
            self.alertView?.activityLabel.text = text
            self.alertView?.progressView.progress = 0.0
        }
    }
    
    func requestStarted(_ request: WaniKaniAPIv2) {}
    
    func requestFinished(_ request: WaniKaniAPIv2) {
        switch request.outcome! {
        case .unauthorized:
            hideActivity(message: "Invalid token")
        case .success:
            switch request {
            case is UserRequest:
                treatNewUser(request: request as! UserRequest)
            case is SubjectsRequest:
                saveSubjects(request: request as! SubjectsRequest)
            default:
                break
            }
        case .jsonError:
            print("jsonError")
        case .error:
            print("Error")
        }
    }
    
    func saveSubjects(request: SubjectsRequest) {
        let wkSubjects: [WKSubject] = request.result as! [WKSubject]

        self.resetActivity(text: "Saving content")
        do {
            try SubjectAssociationsFacade(context: storeContainer.newBackgroundContext(), progressDelegate: self).buildAndAssociate(wkSubjects: wkSubjects)
            self.hideActivity(message: nil)
        } catch {
            // TODO: alert user
            print("error when calling SubjectAssociationsFacade: \(error.localizedDescription)")
        }
    }
    

    func saveNewUserAndRequestSubjects(_ newUser: WKUser, request: UserRequest, userUpdate: UserUpdate) {
        resetActivity(text: "Saving user")
        DispatchQueue.main.async {
            self.userStoreFacade.storeUser(newUser: newUser)
        }
        self.showUser(newUser)
        
        resetActivity(text: "Downloading content")
        requestSubjects(token: request.token, delegate: self, levels: 1...userUpdate.newLevel)
    }
    
    func requestSubjects(token: String, delegate: RequestDelegate, levels: ClosedRange<Int>) {
        SubjectsRequest(token: token,
                        delegate: self,
                        levels: levels
        ).initiate()
    }
    
    func upgradeUser(_ newUser: WKUser, _ comparison: UserUpdate, _ request: UserRequest) {
        resetActivity(text: "Updating user")
        DispatchQueue.main.async {
            self.userStoreFacade.storeUser(newUser: newUser)
        }
        self.showUser(newUser)
        
        let range = max(1, comparison.oldLevel)...comparison.newLevel
        
        resetActivity(text: "Downloading content")
        SubjectsRequest(token: request.token,
                        delegate: self,
                        levels: range
        ).initiate()
    }
    
    func downgradeUser(newUser: WKUser, oldLevel: Int) throws {
        self.showActivity(text: "Updating content")
        self.userStoreFacade.storeUser(newUser: newUser)
        self.showUser(newUser)
        
        let highestLevelToKeep = newUser.data.level
        let levelRangeToDelete = (highestLevelToKeep+1)...
        
        let facade = EntityStoreFacade(context: storeContainer.viewContext)
        do {
            try facade.remove(from: levelRangeToDelete)
            self.hideActivity(message: nil)
        } catch let error as NSError {
            throw error
        }
    }
    
    func updateUserWithoutLeveling(_ newUser: WKUser) {
        DispatchQueue.main.async {
            self.userStoreFacade.storeUser(newUser: newUser)
        }
        self.showUser(newUser)
        self.hideActivity(message: nil)
    }
    
    func treatNewUser(request: UserRequest) {
        let newUser = request.result as! WKUser
        let comparison = self.userStoreFacade.updateType(newUser: newUser)
        
        switch comparison.type {
        case .newUser:
            saveNewUserAndRequestSubjects(newUser, request: request, userUpdate: comparison)
        case .sameLevel:
            updateUserWithoutLeveling(newUser)
        case .higherLevel:
            upgradeUser(newUser, comparison, request)
        case .lowerLevel:
            self.requestUserDowngradeWarning(newUser: newUser, oldLevel: comparison.oldLevel, newLevel: comparison.newLevel)
        }
    }
    
    func error(_ request: WaniKaniAPIv2, reason: String) {
        DispatchQueue.main.async {
            self.hideActivity(message: reason)
        }
    }
    
    func requestUserDowngradeWarning(newUser: WKUser, oldLevel: Int, newLevel: Int) {
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
            
            let alert = UIAlertController(
                title: "Reduce level?",
                message: "New level would be lower than what's currently stored in RfWK. Do you want to adjust your current level from \(oldLevel) back to \(newLevel)?\n\nThis will not affect your WaniKani account progress.",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            
            alert.addAction(
                UIAlertAction(title: "Confirm", style: .destructive) { (_) in
                    do {
                        try self.downgradeUser(newUser: newUser, oldLevel: oldLevel)
                    } catch {
                        // TODO: alert user
                        print("Error: \(error.localizedDescription)")
                    }
                }
            )

            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UITextFieldDelegate

extension AccountViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tokenTextField {
            submitToken(tokenTextField as Any)
        }
        
        return false
    }
}

// MARK: - ProgressDelegate

extension AccountViewController : ProgressDelegate {
    func progress(_ value: Float) {
        DispatchQueue.main.async {
            self.alertView?.progressView.progress = value
        }
    }
}

