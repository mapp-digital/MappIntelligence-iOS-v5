import AVFoundation
import UIKit

final class EpisodeVideoCell: UICollectionViewCell {
    static let reuseIdentifier = "EpisodeVideoCell"

    private let titleLabel = UILabel()
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        pause()
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player = nil
        titleLabel.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = contentView.bounds
        titleLabel.frame = CGRect(x: 12, y: 12, width: contentView.bounds.width - 24, height: 22)
    }

    func configure(title: String, url: URL) {
        titleLabel.text = title
        let player = AVPlayer(url: url)
        self.player = player

        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        playerLayer = layer
        contentView.layer.insertSublayer(layer, at: 0)
        setNeedsLayout()
    }

    func play() {
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    private func configureUI() {
        contentView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        titleLabel.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        titleLabel.layer.cornerRadius = 6
        titleLabel.layer.masksToBounds = true
        titleLabel.textAlignment = .center

        contentView.addSubview(titleLabel)
    }
}
