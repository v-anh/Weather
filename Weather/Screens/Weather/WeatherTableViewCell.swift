//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import UIKit
import Combine

class WeatherTableViewCell: UITableViewCell {
    static let identifier: String = "WeatherTableViewCell"
    
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var dateValue: UILabel!
    @IBOutlet weak var tempTitle: UILabel!
    @IBOutlet weak var tempValue: UILabel!
    @IBOutlet weak var presureTitle: UILabel!
    @IBOutlet weak var presureValue: UILabel!
    @IBOutlet weak var humidityTitle: UILabel!
    @IBOutlet weak var humidityValue: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var descriptionValue: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    private lazy var dateFormatter: DateFormatter =  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM y"
        return dateFormatter
    }()
    
    private var cancellable: AnyCancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherIcon.image = nil
        cancellable?.cancel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        dateTitle.text = "Date:"
        tempTitle.text = "Average Temperature:"
        presureTitle.text = "Pressure:"
        humidityTitle.text = "Humidity:"
        descriptionTitle.text = "Description:"

    }
    
    func bindModel(_ model: WeatherDisplayModel) {
        cancellable = ImageLoader.shared.loadImage(from: model.iconUrl,
                                                   size: weatherIcon.frame.size)
            .sink { [weak self] image in
                guard let self = self,
                      let image = image else {
                    return
                }
                self.weatherIcon.image = image
            }
        tempValue.text = "\(model.averageTemp)"
        dateTitle.text = dateFormatter.string(from: Date(timeIntervalSince1970: model.date))
        presureValue.text = "\(model.pressure)"
        humidityValue.text = "\(model.pressure)%"
        descriptionValue.text = model.description
        
    }
    
}
