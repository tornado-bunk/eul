//
//  StatusMenuView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct StatusMenuView: SizeChangeView {
    @EnvironmentObject var uiStore: UIStore
    @EnvironmentObject var preferenceStore: PreferenceStore
    @EnvironmentObject var menuComponentsStore: ComponentsStore<EulMenuComponent>

    var onSizeChange: ((CGSize) -> Void)?
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("eul")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                Text("v\(preferenceStore.version ?? "?")")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.secondary)
                if preferenceStore.isUpdateAvailable == true {
                    Text("ui.new_version".localized())
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(Color.accentColor)
                        )
                }
                Spacer()
                MenuActionTextView(id: "menu.preferences", text: "menu.preferences", action: AppDelegate.openPreferences)
                MenuActionTextView(id: "menu.quit", text: "menu.quit", action: AppDelegate.quit)
            }
            .padding(.bottom, 2)
            ForEach(menuComponentsStore.activeComponents) {
                $0.getView()
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .frame(minWidth: uiStore.menuWidth)
        .fixedSize()
        .animation(.none)
        .background(GeometryReader { self.reportSize($0) })
        .onPreferenceChange(SizePreferenceKey.self, perform: { value in
            if let size = value.first {
                onSizeChange?(size)
            }
        })
        .preferredColorScheme()
    }
}
