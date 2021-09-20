//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import UIKit

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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindModel(_ model: WeatherFactor) {
        tempValue.text = "\(model.temp?.eve ?? 0)"
        descriptionValue.text = model.weather?.first?.weatherDescription ?? ""
    }
    
}
