import UIKit

final class AlertFactory {
    
    static func createContextMenu(trackerInfo: TrackerInfoCell, isPinned: Bool, pinTrackerHandler: @escaping (Tracker) -> Void, editTrackerHandler: @escaping (TrackerInfoCell) -> Void, deleteTrackerHandler: @escaping (Tracker) -> Void) -> UIMenu {
        
        let tracker = Tracker(
            id: trackerInfo.id,
            name: trackerInfo.name,
            color: trackerInfo.color,
            emoji: trackerInfo.emoji,
            schedule: trackerInfo.schedule,
            state: trackerInfo.state,
            isPinned: isPinned
        )
        
        let pinTitle = isPinned ? "unpin" : "pin"
        
        let pinAction = UIAction(title: NSLocalizedString(pinTitle, comment: "")) { _ in
            pinTrackerHandler(tracker)
        }
        
        let editAction = UIAction(title: NSLocalizedString("edit", comment: "")) { _ in
            editTrackerHandler(trackerInfo)
        }
        
        let deleteAction = UIAction(title: NSLocalizedString("delete", comment: ""), attributes: .destructive) { _ in
            deleteTrackerHandler(tracker)
        }
        
        deleteAction.accessibilityIdentifier = "deleteTracker"
        
        return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
    }
}

