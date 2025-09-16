//
//  FeedCellView.swift
//  MarvelApp
//
//  Created by Felipe Demetrius Martins da Silva on 15/09/25.
//

import SwiftUI

public struct FeedCellView<T>: View where T: FeedCellStateProtocol {
    @ObservedObject var state: T
    
    public init(state: T) {
        self.state = state
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 8) {
            if let image = state.image {
                image
                .resizable()
                .scaledToFit()
                .frame(width: 500, height: 500)
            } else {
                VStack{}
                .frame(width: 500, height: 500)
                .background(Color.gray)
                .shimmer(when: $state.onImageLoading)
                .overlay(alignment: .center) {
                    if state.showRetryImageLoad {
                        VStack {
                            Spacer()
                            Button {
                                state.loadImage()
                            } label: {
                                Text("↻")
                                    .font(.system(size: 350, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                            }
                            .focusSection()
                            Spacer()
                        }
                    }
                }
            }
            Text(state.character.name)
                .font(.system(.largeTitle))
        }.onAppear(perform: {
            state.loadImage()
        })
        .onDisappear(perform: {
            state.cancelImageDataLoad()
        })
        .focusSection()
    }
}
