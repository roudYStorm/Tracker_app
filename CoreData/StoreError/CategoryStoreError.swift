import Foundation

enum CategoryStoreError: Error {
    case decodingTitleError
    case decodingTrackersError
    case addNewTrackerError
    case fetchingCategoryError
}

