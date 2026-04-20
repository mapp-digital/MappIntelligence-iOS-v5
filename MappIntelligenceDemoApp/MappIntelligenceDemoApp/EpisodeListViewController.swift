import UIKit

final class EpisodeListViewController: UIViewController {
    private struct Episode {
        let id: String
        let title: String
        let url: URL
    }

    private let episodes: [Episode] = [
        Episode(id: "episode-1", title: "Episode 1", url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!),
        Episode(id: "episode-2", title: "Episode 2", url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!),
        Episode(id: "episode-3", title: "Episode 3", url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4")!),
        Episode(id: "episode-4", title: "Episode 4", url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4")!),
        Episode(id: "episode-5", title: "Episode 5", url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")!),
        Episode(id: "episode-6", title: "Episode 6", url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")!),
        Episode(id: "episode-7", title: "Episode 7", url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4")!),
        Episode(id: "episode-8", title: "Episode 8", url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4")!),
        Episode(id: "episode-9", title: "Episode 9", url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4")!),
        Episode(id: "episode-10", title: "Episode 10", url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4")!)
    ]

    private let collectionView: UICollectionView
    private let trackingCoordinator = MediaTrackingCoordinator(adapter: MappIntelligenceMediaTrackingAdapter())

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 220)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 220)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episodes"
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }

        collectionView.backgroundColor = .clear
        collectionView.register(EpisodeVideoCell.self, forCellWithReuseIdentifier: EpisodeVideoCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension EpisodeListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        episodes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeVideoCell.reuseIdentifier, for: indexPath)
        guard let episodeCell = cell as? EpisodeVideoCell else {
            return cell
        }

        let episode = episodes[indexPath.item]
        episodeCell.configure(title: episode.title, url: episode.url)
        return episodeCell
    }
}

extension EpisodeListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let episodeCell = cell as? EpisodeVideoCell else { return }
        let episode = episodes[indexPath.item]

        trackingCoordinator.record(action: .play, for: episode.id)
        episodeCell.play()
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let episodeCell = cell as? EpisodeVideoCell else { return }
        let episode = episodes[indexPath.item]

        trackingCoordinator.record(action: .pause, for: episode.id)
        episodeCell.pause()
    }
}
