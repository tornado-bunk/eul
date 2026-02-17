//
//  GPUWidgetBundle.swift
//  GPUWidget
//
//  Created by Corrado Belmonte on 17/02/26.
//  Copyright © 2026 Gao Sun. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct GPUWidgetBundle: WidgetBundle {
    var body: some Widget {
        GPUWidget()
        GPUWidgetControl()
    }
}
