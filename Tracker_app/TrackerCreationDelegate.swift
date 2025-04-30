import Foundation

protocol TrackerCreationDelegate: AnyObject {
    func createTracker(tracker: Tracker, category: String)
}

