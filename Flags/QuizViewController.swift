//
//  QuizViewController.swift
//  Flags
//
//  Created by Benjamin Lopez on 06/01/2017.
//  Copyright © 2017 Scotow. All rights reserved.
//

import UIKit
import GameplayKit

class QuizViewController: UIViewController, UIViewControllerPreviewingDelegate, UITabBarControllerDelegate {
    
    // MARK: Outlet
    @IBOutlet weak var mainStack: UIStackView!
    
    // MARK: Properties
    private var buttons = [UIButton]()
    
    private var countries: [String]!
    private var score = 0
    private var correctAnswer = 0
    
    var difficulty = 4 {
        didSet {
            setupDifficulty()
            askQuestion()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tabBarController?.delegate = self
        
        setupDifficulty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        score = 0
        askQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Peek and pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return nil
        }
        
        guard previewingContext.sourceView.tag >= 0 && previewingContext.sourceView.tag < difficulty else {
            return nil
        }
        
        detailViewController.flag = countries[previewingContext.sourceView.tag]
        
        return detailViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        //navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    // MARK: Private functions
    private func askQuestion(action: UIAlertAction? = nil) {
        countries = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: BrowseTableViewController.countries) as! [String]
        correctAnswer = GKRandomSource.sharedRandom().nextInt(upperBound: difficulty)
        
        for (index, button) in buttons.enumerated() {
            button.setImage(UIImage(named: countries[index]), for: .normal)
        }
        
        navigationItem.title = countries[correctAnswer].replacingOccurrences(of: "_", with: " ")
        
        slideFlagsIn()
    }
    
    private func setupDifficulty() {
        // Reset score.
        score = 0
        
        // Clear any existing buttons.
        for subView in mainStack.arrangedSubviews {
            mainStack.removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
        buttons.removeAll()
        
        var previousButton: UIButton!
        
        // Layout based on number of flags.
        if difficulty > 4 && difficulty % 2 == 0 {
            for stackIndex in 0..<difficulty/2 {
                // Create stacks
                let subStack = UIStackView()
                mainStack.addArrangedSubview(subStack)
                
                // Substacks spacing.
                subStack.spacing = 20
                
                // Add two buttons per substack.
                for index in 0..<2 {
                    let button = UIButton()
                    buttons.append(button)
                    
                    // Set button tag.
                    button.tag = stackIndex * 2 + index
                    
                    // Add the button to the substack.
                    subStack.addArrangedSubview(button)
                    
                    // Constraints
                    button.translatesAutoresizingMaskIntoConstraints = false
                    
                    // Equal heigth to all buttons.
                    if previousButton != nil {
                        button.heightAnchor.constraint(equalTo: previousButton.heightAnchor).isActive = true
                    }
                    
                    // Aspect ratio constraints.
                    button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1.5).isActive = true
                    
                    // Set border width and color to flags.
                    button.layer.borderWidth = 1
                    button.layer.borderColor = UIColor.gray.cgColor
                    
                    // Register tab to force touch.
                    if traitCollection.forceTouchCapability == .available {
                        registerForPreviewing(with: self, sourceView: button)
                    }
                    
                    // Register event on tap.
                    button.addTarget(self, action: #selector(flagTapped(button:)), for: .touchUpInside)
                    
                    previousButton = button
                }
            }
        } else {
            // Create buttons.
            for index in 0..<difficulty {
                let button = UIButton()
                buttons.append(button)
                
                // Set button tag.
                button.tag = index
                
                // Add the button to the stack view.
                mainStack.addArrangedSubview(button)
                
                // Constraints
                button.translatesAutoresizingMaskIntoConstraints = false
                //button.heightAnchor.constraint(equalToConstant: 100).isActive = true
                
                // Equal heigth to all buttons.
                if previousButton != nil {
                    button.heightAnchor.constraint(equalTo: previousButton.heightAnchor).isActive = true
                }
                
                // Aspect ratio constraints.
                button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1.5).isActive = true
                
                // Set border width and color to flags.
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.gray.cgColor
                
                // Register tab to force touch.
                if traitCollection.forceTouchCapability == .available {
                    registerForPreviewing(with: self, sourceView: button)
                }
                
                // Register event on tap.
                button.addTarget(self, action: #selector(flagTapped(button:)), for: .touchUpInside)
                
                previousButton = button
            }
        }
    }
    
    func slideFlagsIn() {
        for (index, flag) in mainStack.arrangedSubviews.enumerated() {
            if index % 2 == 0 {
                flag.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
            } else {
                flag.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
            }
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                flag.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    func slideFlagsOut(completion: ((Void) -> Void)? = nil) {
        for (index, flag) in mainStack.arrangedSubviews.enumerated() {
            let destination: CGAffineTransform
            if index % 2 == 0 {
                destination = CGAffineTransform(translationX: view.bounds.width, y: 0)
            } else {
                destination = CGAffineTransform(translationX: -view.bounds.width, y: 0)
            }
            UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseIn, animations: {
                flag.transform = destination
            }, completion: nil)
        }
    }
    
    func flagTapped(button: UIButton) {
        slideFlagsOut()
        
        var title: String
        
        if button.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score = score > 0 ? score - 1 : 0
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
    func requestDifficultyChange(_ action: UIAlertAction) {
        guard let alertTitle = action.title else {
            return
        }
        
        guard let requestedDifficulty = Int(alertTitle) else {
            return
        }
        
        difficulty = requestedDifficulty
    }

    // MARK: Actions
    @IBAction func difficultyTapped(_ sender: UIBarButtonItem) {
        var availableDifficulties = [2, 3, 4, 6, 8]
        
        // Remove aactual difficulty from the alert pop-up.
        if let indexOfActualDifficulty = availableDifficulties.index(of: difficulty) {
            availableDifficulties.remove(at: indexOfActualDifficulty)
        }
        
        let ac = UIAlertController(title: "Difficulty", message: "How many flags do you want to display ?\nChanging difficulty will reset your score.", preferredStyle: .actionSheet)
        
        for title in availableDifficulties {
            ac.addAction(UIAlertAction(title: String(title), style: .default, handler: requestDifficultyChange))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true, completion: nil)
    }
    
    // MARK: TabBar delegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // Switching to browse bar
        if viewController is UINavigationController && (viewController as! UINavigationController).viewControllers.first is
            BrowseTableViewController {
            
            if score == 0 {
                return true
            } else {
                let ac = UIAlertController(title: "Browsing flags", message: "Switching to flags browsing will reset your score. Confirm ?", preferredStyle: .actionSheet)
                ac.addAction(UIAlertAction(title: "Confirm", style: .destructive) { [unowned tabBarController, viewController] (action) in
                    tabBarController.selectedViewController = viewController
                })
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                present(ac, animated: true, completion: nil)
                return false
            }
        }
        return true
    }

}

