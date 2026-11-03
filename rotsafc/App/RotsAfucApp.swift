//
//  RotsAfucApp.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import SwiftUI

@main
struct RotsAfucApp: App {
    private let repository = Result { try SwiftDataThoughtRepository() }

    var body: some Scene {
        WindowGroup {
            switch repository {
            case .success(let repository):
                AppRootView(repository: repository)
            case .failure:
                ContentUnavailableView(
                    "Your thoughts can’t be opened",
                    systemImage: "exclamationmark.triangle",
                    description: Text("Restart RotsAfuc4. If this keeps happening, free up some storage.")
                )
            }
        }
    }
}
