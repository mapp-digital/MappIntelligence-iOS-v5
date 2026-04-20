import Foundation

final class MediaTrackingCoordinator {
    private let adapter: MediaTrackingAdapter
    private var initializedEpisodes = Set<String>()

    init(adapter: MediaTrackingAdapter) {
        self.adapter = adapter
    }

    func record(action: MediaTrackingAction, for episodeId: String) {
        if !initializedEpisodes.contains(episodeId) {
            initializedEpisodes.insert(episodeId)
            adapter.trackMedia(action: .initialize, episodeId: episodeId)
        }

        if action != .initialize {
            adapter.trackMedia(action: action, episodeId: episodeId)
        }
    }

    func resetEpisode(_ episodeId: String) {
        initializedEpisodes.remove(episodeId)
    }

    func resetAll() {
        initializedEpisodes.removeAll()
    }
}
