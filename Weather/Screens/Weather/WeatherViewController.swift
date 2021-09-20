//
//  WeatherViewController.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import UIKit
import Combine

class WeatherViewController: UIViewController {

    private var cancellable = Set<AnyCancellable>()
    private let viewModel: WeatherViewModelType
    private let search = PassthroughSubject<String, Never>()
    private let viewDidAppear = PassthroughSubject<Void, Never>()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var dataSource = makeDataSource()
    @IBOutlet weak var tableView: UITableView!
    //    lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: .zero)
//        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherTableViewCell")
//        return tableView
//    }()
    
    init(viewModel: WeatherViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: "WeatherViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderUI()
        bindViewModel(viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppear.send(())
    }
}

extension WeatherViewController {
    func renderUI() {
//        view.backgroundColor = .white
//        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        view.translatesAutoresizingMaskIntoConstraints = false
//        let constraints = [
//            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0),
//        ]
//        NSLayoutConstraint.activate(constraints)
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        tableView.tableFooterView = UIView()
        tableView.dataSource = dataSource
        navigationItem.searchController = self.searchController
        searchController.isActive = true
    }
    
    func bindViewModel(_ viewModel: WeatherViewModelType) {
        cancellable.forEach{$0.cancel()}
        cancellable.removeAll()
        let input = WeatherViewModelInput(loadView: viewDidAppear.eraseToAnyPublisher(),
                                          search: search.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.weatherSearchOutput.sink { [weak self] state in
            guard let self = self else {return}
            self.updateView(state)
        }.store(in: &cancellable)
    }
    
    func updateView(_ state: SearchWeatherState) {
        print("Update view with state: \(state)")
        switch state {
        case .empty:
            break
        case .loaded(let weatherList):
            DispatchQueue.main.async {
                var snapshot = NSDiffableDataSourceSnapshot<WeatherSection, WeatherFactor>()
                snapshot.appendSections(WeatherSection.allCases)
                snapshot.appendItems(weatherList, toSection: .list)
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
        case .loading:
            break;
        case .haveError(_):
            break;
        }
    }
}

enum WeatherSection: CaseIterable {
    case list
}

extension WeatherViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<WeatherSection, WeatherFactor> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, wetherFactor in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier) as? WeatherTableViewCell else {
                    fatalError("Can not dequeue \(WeatherTableViewCell.self)!")
                    return UITableViewCell()
                }
                cell.bindModel(wetherFactor)
                return cell
            }
        )
    }
}

extension WeatherViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search.send(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search.send("")
    }
}

extension WeatherViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}
