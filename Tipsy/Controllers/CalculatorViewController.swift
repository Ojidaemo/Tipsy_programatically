//
//  CalculatorViewController.swift
//  Tipsy
//
//  Created by Vitali Martsinovich on 2023-01-31.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    var numberOfPeopleToSplit = 2
    var totalBill = 0.0
    var tip = 0.10
    var finalSplit = "0.0"
    
    //MARK: - UI Elements
    
    lazy var tipsButtons = [zeroTipButton, tenTipButton, twentyTipButton]
    
    private let secondView: UIView = {
        let secondView = UIView()
        secondView.backgroundColor = #colorLiteral(red: 0.7364435792, green: 0.8989037871, blue: 0.9391706586, alpha: 1)
        secondView.translatesAutoresizingMaskIntoConstraints = false
        return secondView
    }()
    
    private let topStackView: UIStackView = {
        let topStack = UIStackView()
        topStack.axis = .vertical
        topStack.distribution = .fill
        topStack.spacing = 28
        topStack.translatesAutoresizingMaskIntoConstraints = false
        
        return topStack
        
    }()
    
    private let middleStackView: UIStackView = {
        let middleStack = UIStackView()
        middleStack.axis = .vertical
        middleStack.distribution = .fill
        middleStack.alignment = .center
        middleStack.spacing = 10
        middleStack.translatesAutoresizingMaskIntoConstraints = false
        
        return middleStack
        
    }()
    
    private lazy var firstStackInsideMiddle: UIStackView = {
        let firstStack = UIStackView(arrangedSubviews: tipsButtons)
        firstStack.axis = .horizontal
        firstStack.distribution = .fillEqually
        firstStack.alignment = .fill
        firstStack.contentMode = .scaleToFill
        firstStack.spacing = 0
        firstStack.translatesAutoresizingMaskIntoConstraints = false
        
        return firstStack
        
    }()
    
    private lazy var secondStackInsideMiddle: UIStackView = {
        
        let firstStack = UIStackView()
        firstStack.axis = .horizontal
        firstStack.distribution = .fill
        firstStack.alignment = .fill
        firstStack.contentMode = .scaleToFill
        firstStack.spacing = 27
        firstStack.translatesAutoresizingMaskIntoConstraints = false
        
        return firstStack
        
    }()
    
    private lazy var splitNumberStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.value = 2
        stepper.minimumValue = 1
        stepper.maximumValue = 25
        stepper.stepValue = 1
        stepper.contentVerticalAlignment = .center
        stepper.contentHorizontalAlignment = .center
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .touchUpInside)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.heightAnchor.constraint(equalToConstant: 29).isActive = true
        stepper.widthAnchor.constraint(equalToConstant: 94).isActive = true
        return stepper
    }()
    
    private lazy var zeroTipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("0%", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0.6901960784, blue: 0.4196078431, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35)
        button.tintColor = #colorLiteral(red: 0, green: 0.6901960784, blue: 0.4196078431, alpha: 1)
        button.addTarget(self, action: #selector(tipChanged), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }()
    
    //TODO: button isSelected
    
    private lazy var tenTipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("10%", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0.6901960784, blue: 0.4196078431, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35)
        button.tintColor = #colorLiteral(red: 0, green: 0.6901960784, blue: 0.4196078431, alpha: 1)
        button.isSelected = true
        button.addTarget(self, action: #selector(tipChanged), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        return button
    }()
    
    private lazy var twentyTipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("20%", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0.6901960784, blue: 0.4196078431, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35)
        button.tintColor = #colorLiteral(red: 0, green: 0.6901960784, blue: 0.4196078431, alpha: 1)
        button.addTarget(self, action: #selector(tipChanged), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        return button
    }()
    
    private lazy var calculateButton: UIButton = {
       let button = UIButton()
        button.setTitle("Calculate", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.6901960784, blue: 0.4196078431, alpha: 1)
        button.titleLabel?.font = .systemFont(ofSize: 35)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(calculateButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var enterBillLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter bill total"
        label.font = .systemFont(ofSize: 25)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    private var selectTipLabel: UILabel = {
        let label = UILabel()
        label.text = "Select tip"
        label.font = .systemFont(ofSize: 25)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    private var chooseSplitLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose split"
        label.font = .systemFont(ofSize: 25)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    private var splitNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "2"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 35)
        label.textColor = #colorLiteral(red: 0, green: 0.6901960784, blue: 0.4196078431, alpha: 1)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 29).isActive = true
        label.widthAnchor.constraint(equalToConstant: 93).isActive = true
        
        return label
        
    }()
    
    private var billTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "e.g. 123.56"
        textField.font = .systemFont(ofSize: 40)
        textField.textColor = #colorLiteral(red: 0, green: 0.6901960784, blue: 0.4196078431, alpha: 1)
        textField.textAlignment = .center
        textField.minimumFontSize = 17
        textField.adjustsFontSizeToFitWidth = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    //MARK: - IB Actions
    
    @objc func calculateButtonPressed(sender: UIButton) {
        
        let secondVC = ResultViewController()
                        
        totalBill = Double(billTextField.text!) ?? 0.0
        print(totalBill)
        
        let result = (totalBill * (1 + tip)) / Double(numberOfPeopleToSplit)
        finalSplit = String(format: "%.2f", result)
        
        secondVC.finalSplit = finalSplit
        secondVC.numberOfPeople = numberOfPeopleToSplit
        secondVC.tipAmount = Int(tip * 100)
        
        self.present(secondVC, animated: true)
        
    }
    
    @objc func tipChanged(sender: UIButton) {
        
        billTextField.endEditing(true)
        
        zeroTipButton.isSelected = false
        tenTipButton.isSelected = false
        twentyTipButton.isSelected = false
        sender.isSelected = true
        
        let titleValueMinusLast = String(sender.currentTitle!.dropLast(1))
        tip = Double(titleValueMinusLast)! / 100
    }
    
    @objc func stepperValueChanged(sender: UIStepper) {
        
        splitNumberLabel.text = String(Int(sender.value))
        numberOfPeopleToSplit = Int(sender.value)
        
    }
    
    //MARK: - Other methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
                
    }
    
    //MARK: - Setting up UI

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addToStack()
        view.addSubview(topStackView)
        view.addSubview(secondView)
        secondView.addSubview(middleStackView)
        secondView.addSubview(calculateButton)
        setConstraints()
        
    }
    
    func addToStack() {
        topStackView.addArrangedSubview(enterBillLabel)
        topStackView.addArrangedSubview(billTextField)
        secondStackInsideMiddle.addArrangedSubview(splitNumberLabel)
        secondStackInsideMiddle.addArrangedSubview(splitNumberStepper)
        middleStackView.addArrangedSubview(selectTipLabel)
        middleStackView.addArrangedSubview(firstStackInsideMiddle)
        middleStackView.addArrangedSubview(chooseSplitLabel)
        middleStackView.addArrangedSubview(secondStackInsideMiddle)

    }
    
    //MARK: - Constraints
    
    func setConstraints() {
        
        NSLayoutConstraint.activate ([
            
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            middleStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor,constant: 20),
            middleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            middleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            
            selectTipLabel.heightAnchor.constraint(equalToConstant: 30),
            selectTipLabel.topAnchor.constraint(equalTo: middleStackView.topAnchor, constant: 5),
            selectTipLabel.leadingAnchor.constraint(equalTo: middleStackView.leadingAnchor,constant: 30),
            selectTipLabel.trailingAnchor.constraint(equalTo: middleStackView.trailingAnchor,constant: -30),
            
            chooseSplitLabel.heightAnchor.constraint(equalToConstant: 30),
            chooseSplitLabel.leadingAnchor.constraint(equalTo: middleStackView.leadingAnchor,constant: 30),
            chooseSplitLabel.trailingAnchor.constraint(equalTo: middleStackView.trailingAnchor,constant: -30),
            
            firstStackInsideMiddle.leadingAnchor.constraint(equalTo: middleStackView.leadingAnchor),
            firstStackInsideMiddle.trailingAnchor.constraint(equalTo: middleStackView.trailingAnchor),
            firstStackInsideMiddle.heightAnchor.constraint(equalToConstant: 54),
            
            secondView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 20),
            secondView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            secondView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            enterBillLabel.heightAnchor.constraint(equalToConstant: 30),
            enterBillLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            enterBillLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            billTextField.heightAnchor.constraint(equalToConstant: 48),
            billTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            billTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            calculateButton.widthAnchor.constraint(equalToConstant: 200),
            calculateButton.heightAnchor.constraint(equalToConstant: 54),
            calculateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calculateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            
        
        
        ])
        
    }

}
