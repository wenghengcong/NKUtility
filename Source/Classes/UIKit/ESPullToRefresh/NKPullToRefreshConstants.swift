//
//  NKPullToRefreshConstants.swift
//  NKUtility
//
//  Created by Hunt on 2021/1/25.
//

import Foundation


fileprivate extension String {
    var localizedInPullToRefresh: String {
        let outString = localizedInside(using: "NKPullToRefresh")
        return outString
    }
}

struct NKPullToRefreshConstants {
    static let l10nStringFile = "NKPullToRefresh"

    static let PullToRefersh = "Pull to refresh".localizedInPullToRefresh
    static let ReleaseToRefresh = "Release to refresh".localizedInPullToRefresh
    static let Loading = "Loading...".localizedInPullToRefresh
    static let LoadingMore = "Loading more".localizedInPullToRefresh
    static let NoMoreData = "No more data".localizedInPullToRefresh

}
