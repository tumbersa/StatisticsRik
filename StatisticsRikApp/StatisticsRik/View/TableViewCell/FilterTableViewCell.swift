//
//  FilterTableViewCell.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 22.05.2025.
//

import Foundation
import UIKit
import Core

final class FilterTableViewCell: UITableViewCell, ReusableView {

    private var isSelectionMade: Bool = false
    private var items: [String] = []
    var onItemSelected: ((String) -> Void)?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FilterCollectionViewCell.self)
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureAppearance()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(items: [String]) {
        self.items = items
        if !isSelectionMade {
            collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
        isSelectionMade = true

        contentView.addSubview(collectionView)
        collectionView.pin.all()
    }

}

private extension FilterTableViewCell {

    func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }

}

extension FilterTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FilterCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.set(title: items[indexPath.item])
        return cell
    }

}

extension FilterTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        onItemSelected?(item)
    }

}

extension FilterTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let item = items[indexPath.item]
        let font = Fonts.gilroySemiBold(size: 15).font
        let attributes = [NSAttributedString.Key.font: font]
        let size = (item as NSString).size(withAttributes: attributes)

        let width = size.width + 32

        return CGSize(width: width, height: 32)
    }
}
