//
//  HorizontalCell.swift
//  Example
//
//  Created by Pedro M. Zaroni on 01/08/20.
//  Copyright © 2020 Dextra. All rights reserved.
//

import UIKit
import ViewCodeHelper

protocol ViewConfigurable: Reusable {
    associatedtype ViewModel
    func configure(with model: ViewModel)
}

final class HorizontalCell: UICollectionViewCell, Reusable, ViewConfigurable {
    typealias ViewModel = String

    private lazy var coverArt = UIImageView()
        .. \.layer.cornerRadius <- 10
        .. \.clipsToBounds <- true

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: ViewModel) {
        coverArt.image = UIImage(named: model)
    }
}

extension HorizontalCell: ViewCodeProtocol {
    func setupHierarchy() {
        contentView.addSubviewWithConstraints(subview: coverArt)
    }

    func setupConstraints() { }
}
