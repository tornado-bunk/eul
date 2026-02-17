//
//  PreferenceSectionView.swift
//  eul
//
//  Created by Gao Sun on 2020/10/24.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

extension Preference {
    enum Section: String, Identifiable, CaseIterable {
        case general
        case components
        case menuView

        var id: String {
            rawValue
        }

        var localizedDescription: String {
            switch self {
            case .general:
                return "ui.general".localized()
            case .components:
                return "ui.components".localized()
            case .menuView:
                return "ui.menu_view".localized()
            }
        }
    }

    struct PreferenceSectionView: View {
        @Binding var activeSection: Section
        let section: Section

        var isActive: Bool {
            activeSection == section
        }

        var body: some View {
            HStack(spacing: 8) {
                Text(section.localizedDescription)
                    .font(.system(size: 12, weight: isActive ? .semibold : .regular))
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                Group {
                    if isActive {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(.thinMaterial)
                            .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 1)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .strokeBorder(Color.white.opacity(0.15), lineWidth: 0.5)
                            )
                    }
                }
            )
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    activeSection = section
                }
            }
        }
    }
}
