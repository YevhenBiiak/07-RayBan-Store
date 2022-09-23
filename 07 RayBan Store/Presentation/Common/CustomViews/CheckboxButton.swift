//
//  CheckboxButton.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 22.09.2022.
//

import UIKit

class CheckboxButton: UIButton {
    private let checkedImage: UIImage
    private let uncheckedImage: UIImage
    
    var isChecked: Bool = false
     
    init(checkedImage: UIImage = UIImage(systemName: "checkmark.square.fill")!
            .withConfiguration(UIImage.SymbolConfiguration(paletteColors: [UIColor.white, UIColor.black])),
         uncheckedImage: UIImage = UIImage(systemName: "square")!
            .withConfiguration(UIImage.SymbolConfiguration(paletteColors: [UIColor.black, UIColor.white])),
         scale: UIImage.SymbolScale) {
        self.checkedImage = checkedImage
        self.uncheckedImage = uncheckedImage
        
        super.init(frame: .zero)
        configuration = UIButton.Configuration.plain()
        configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: scale)
        
        addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            
            switch self.isChecked {
            case false: self.setImage(self.checkedImage, for: .normal)
            case true: self.setImage(self.uncheckedImage, for: .normal)
            }
            
            self.isChecked.toggle()
            
        }), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // set initial state image
        setImage(self.uncheckedImage, for: .normal)
    }
}
