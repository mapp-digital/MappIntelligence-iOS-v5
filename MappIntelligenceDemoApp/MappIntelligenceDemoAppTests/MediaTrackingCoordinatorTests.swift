import Testing
@testable import MappIntelligenceDemoApp

@Suite("Media tracking")
struct MediaTrackingCoordinatorTests {
    private final class RecordingAdapter: MediaTrackingAdapter {
        struct Entry: Equatable {
            let episodeId: String
            let action: MediaTrackingAction
        }

        private(set) var entries: [Entry] = []

        func trackMedia(action: MediaTrackingAction, episodeId: String) {
            entries.append(Entry(episodeId: episodeId, action: action))
        }
    }

    @Test("Sends init before play/pause for each episode")
    func sendsInitBeforePlayAndPause() {
        let adapter = RecordingAdapter()
        let coordinator = MediaTrackingCoordinator(adapter: adapter)

        let episodes = ["episode-1", "episode-2", "episode-3", "episode-4", "episode-5"]
        for episode in episodes {
            coordinator.record(action: .play, for: episode)
            coordinator.record(action: .pause, for: episode)
        }

        for episode in episodes {
            let episodeEntries = adapter.entries.filter { $0.episodeId == episode }
            #expect(episodeEntries.count == 3)
            #expect(episodeEntries.first?.action == .initialize)
            #expect(episodeEntries[1].action == .play)
            #expect(episodeEntries[2].action == .pause)
        }
    }

    @Test("Does not duplicate init for repeated actions")
    func doesNotDuplicateInit() {
        let adapter = RecordingAdapter()
        let coordinator = MediaTrackingCoordinator(adapter: adapter)

        coordinator.record(action: .play, for: "episode-1")
        coordinator.record(action: .pause, for: "episode-1")
        coordinator.record(action: .play, for: "episode-1")

        let actions = adapter.entries.map { $0.action }
        #expect(actions == [.initialize, .play, .pause, .play])
    }
}
