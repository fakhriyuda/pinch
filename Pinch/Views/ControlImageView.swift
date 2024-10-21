//
//  ControlImageView.swift
//  Pinch
//
//  Created by ISYS Macbook air 1 on 18/10/24.
//

import SwiftUI

struct ControlImageView: View {
    let icon : String
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 34))
    }
}

#Preview {
    ControlImageView(icon: "minus.magnifyingglass")
}
