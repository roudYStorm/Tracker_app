import Foundation

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
    // MARK: - Public Properties
    let title: String
    let trackers: [Tracker]
    
    var titleBinding: Binding<String>? {
        didSet {
            titleBinding?(title)
        }
    }
    
    var trackersBinding: Binding<[Tracker]>? {
        didSet {
            trackersBinding?(trackers)
        }
    }
    
    // MARK: - Initializers
    init(title: String, trackers: [Tracker]) {
        self.title = title
        self.trackers = trackers
    }
}

