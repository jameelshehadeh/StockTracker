//
//  CustomSortMenu.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 04/04/2026.
//

import SwiftUI

struct CustomSortMenu: View {
    
    let selectedSortType: SortOption
    let didTapSortType: (SortOption) -> Void
    
    var body: some View {
        Menu {
            Button {
                didTapSortType(.byPrice)
            } label: {
                HStack {
                    Text("By Price")
                    if selectedSortType == .byPrice {
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            Button {
                didTapSortType(.byPriceChange)
            } label: {
                HStack {
                    Text("By Price Change")
                    if selectedSortType == .byPriceChange {
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
            }
            
        } label: {
            HStack {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 14))
                Text("Sort")
                    .fontWeight(.bold)
            }
        }
    }
}

#Preview {
    CustomSortMenu.init(selectedSortType: .byPrice) { selectedOption in
        
    }
}
