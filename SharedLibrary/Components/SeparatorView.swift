//
//  SeparatorView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

public struct SeparatorView: View {
    public init(padding: CGFloat = 4) {
        self.padding = padding
    }

    public var padding: CGFloat = 4

    public var body: some View {
        Rectangle()
            .fill(Color.separator.opacity(0.4))
            .frame(height: 0.5)
            .padding(.vertical, padding)
    }
}
