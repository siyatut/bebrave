//
//  UICollectionView+SupplementaryView.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 17/12/2567 BE.
//

import UIKit

extension UICollectionView {
    func dequeueSupplementaryView<T: UICollectionReusableView>(
        ofKind kind: String,
        withReuseIdentifier reuseIdentifier: String,
        for indexPath: IndexPath
    ) throws -> T {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as? T else {
            throw SupplementaryViewError.dequeuingFailed(kind: kind, reuseIdentifier: reuseIdentifier)
        }
        return view
    }
}
