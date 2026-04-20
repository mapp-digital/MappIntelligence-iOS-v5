import Foundation

protocol MediaTrackingAdapter {
    func trackMedia(action: MediaTrackingAction, episodeId: String)
}

enum MediaTrackingAction: String {
    case initialize
    case play
    case pause
}

final class MappIntelligenceMediaTrackingAdapter: MediaTrackingAdapter {
    func trackMedia(action: MediaTrackingAction, episodeId: String) {
        let actionValue: String
        switch action {
        case .initialize:
            actionValue = "init"
        case .play:
            actionValue = "play"
        case .pause:
            actionValue = "pause"
        }

        // Keep duration and position at zero; the tracker should still register the init/play/pause sequence.
        print("action: \(actionValue) and episodeId: \(episodeId)")
        let mediaProperties = MIMediaParameters(episodeId, action: actionValue, position: 0, duration: 0)
        let mediaEvent = MIMediaEvent(pageName: "MediaTracking", parameters: mediaProperties)
        MappIntelligence.shared()?.trackMedia(mediaEvent)
    }
}
