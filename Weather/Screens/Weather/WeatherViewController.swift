//
//  WeatherViewController.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import UIKit
import Combine

class WeatherViewController: BaseViewController {
    
    private typealias DataSource = UITableViewDiffableDataSource<WeatherViewModel.WeatherSection, WeatherDisplayModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<WeatherViewModel.WeatherSection, WeatherDisplayModel>

    private var cancellable = Set<AnyCancellable>()
    private let viewModel: WeatherViewModelType
    private let search = PassthroughSubject<String, Never>()
    private let viewDidAppear = PassthroughSubject<Void, Never>()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var dataSource = configdataSource()
    @IBOutlet weak var tableView: UITableView!
    
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
        self.title = "Weather Forecast"
        setupTableView()
        setupSearchUI()
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
            self.updateDataSource([])
            self.finishLoading()
        case .loaded(let weatherList):
            self.finishLoading()
            self.updateDataSource(weatherList)
        case .loading:
            self.startLoading()
            break;
        case .haveError(let error):
            self.finishLoading()
            self.showError(error)
        }
    }
}


//MARK: - Weather Tableview
extension WeatherViewController {
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = dataSource
        tableView.register(UINib(nibName: WeatherTableViewCell.className, bundle: nil), forCellReuseIdentifier: WeatherTableViewCell.identifier)
    }
    
    private func configdataSource() -> DataSource {
        return DataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, wetherFactor in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier) as? WeatherTableViewCell else {
                    fatalError("Can not dequeue \(WeatherTableViewCell.self)!")
                }
                cell.bindModel(wetherFactor)
                return cell
            }
        )
    }
    
    private func updateDataSource(_ weatherList: [WeatherDisplayModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.weatherList])
        snapshot.appendItems(weatherList, toSection: .weatherList)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}


//MARK: Search Bar
extension WeatherViewController: UISearchBarDelegate {
    private func setupSearchUI() {
        searchController.isActive = true
        navigationItem.searchController = self.searchController
    }
    
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
