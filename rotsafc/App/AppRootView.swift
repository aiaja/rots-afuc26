//
//  AppRootView.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import SwiftUI

/// Chooses between first-run onboarding and the journal.
struct AppRootView: View {
    let repository: any ThoughtRepository

    @AppStorage("hasMetChick") private var hasMetChick = false
    @State private var justMetChick = false

    var body: some View {
        JournalRootView(repository: repository, greetsOnAppear: justMetChick)
    }
}

