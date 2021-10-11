//
//  FarmTableViewCell.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 10/9/21.
//

import UIKit

class FarmTableViewCell: UITableViewCell {
    static let reuseId = "FarmTableViewCell"

    lazy var farmLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Farm: "
        return label
    }()

    lazy var farmNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    lazy var cropLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Crop: "
        return label
    }()

    lazy var cropTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Location: "
        return label
    }()

    lazy var locationCoordinatesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Distance: "
        return label
    }()

    lazy var distanceAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Time: "
        return label
    }()

    lazy var timeAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    func configureConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),

            farmLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            farmLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            farmLabel.widthAnchor.constraint(equalToConstant: 75),
            farmLabel.bottomAnchor.constraint(equalTo: cropLabel.topAnchor, constant: -8),

            farmNameLabel.topAnchor.constraint(equalTo: farmLabel.topAnchor),
            farmNameLabel.leadingAnchor.constraint(equalTo: farmLabel.trailingAnchor, constant: 8),
            farmNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            farmNameLabel.bottomAnchor.constraint(equalTo: farmLabel.bottomAnchor),

            cropLabel.topAnchor.constraint(equalTo: farmLabel.bottomAnchor, constant: 8),
            cropLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cropLabel.widthAnchor.constraint(equalToConstant: 75),
            cropLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -8),

            cropTypeLabel.topAnchor.constraint(equalTo: cropLabel.topAnchor),
            cropTypeLabel.leadingAnchor.constraint(equalTo: cropLabel.trailingAnchor, constant: 8),
            cropTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            cropTypeLabel.bottomAnchor.constraint(equalTo: cropLabel.bottomAnchor),

            locationLabel.topAnchor.constraint(equalTo: cropLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            locationLabel.widthAnchor.constraint(equalToConstant: 75),
            locationLabel.bottomAnchor.constraint(equalTo: distanceLabel.topAnchor, constant: -8),

            locationCoordinatesLabel.topAnchor.constraint(equalTo: locationLabel.topAnchor),
            locationCoordinatesLabel.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: 8),
            locationCoordinatesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            locationCoordinatesLabel.bottomAnchor.constraint(equalTo: locationLabel.bottomAnchor),

            distanceLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            distanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            distanceLabel.widthAnchor.constraint(equalToConstant: 75),
            distanceLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -8),

            distanceAmountLabel.topAnchor.constraint(equalTo: locationCoordinatesLabel.bottomAnchor, constant: 8),
            distanceAmountLabel.leadingAnchor.constraint(equalTo: distanceLabel.trailingAnchor, constant: 8),
            distanceAmountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            distanceAmountLabel.bottomAnchor.constraint(equalTo: distanceLabel.bottomAnchor),

            timeLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            timeLabel.widthAnchor.constraint(equalToConstant: 75),
            timeLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),

            timeAmountLabel.topAnchor.constraint(equalTo: distanceAmountLabel.bottomAnchor, constant: 8),
            timeAmountLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 8),
            timeAmountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            timeAmountLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(farmLabel)
        contentView.addSubview(farmNameLabel)
        contentView.addSubview(cropLabel)
        contentView.addSubview(cropTypeLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(locationCoordinatesLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(distanceAmountLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(timeAmountLabel)
        configureConstraints()
    }

     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
