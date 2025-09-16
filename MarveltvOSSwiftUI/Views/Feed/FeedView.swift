//
//  MarveltvOSSwiftUI.swift
//  MarveltvOSSwiftUI
//
//  Created by Felipe Demetrius Martins da Silva on 15/09/25.
//

import Foundation
import SwiftUI
import FeatureFeed
import UIKit

public struct FeedView<T>: View where T: FeedViewModelProtocol {
    @ObservedObject var viewModel: T
    @FocusState var focusedField: Character?
    
    public init(viewModel: T) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(viewModel.title)
                .font(.system(.largeTitle))

            ScrollView (.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(viewModel.characters, id: \.self) { char in
                        Button {
                            print("model \(char.character)")
                        } label: {
                            
                            FeedCellView(state: char)
                        }
                        .buttonStyle(.borderless)
                        .focused($focusedField, equals: char.character)
                    }
                    if viewModel.characters.isEmpty {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .frame(height: 600)
            
            //Character Description
            HStack {
                VStack (alignment: .leading, spacing: 40) {
                    Text(focusedField?.description ?? "-")
                        .font(.system(.caption))
                }
                .padding(.leading, 40)
                Spacer()
            }
            .opacity(focusedField != nil ? 1 : 0)
            Spacer()
        }
    }
}
