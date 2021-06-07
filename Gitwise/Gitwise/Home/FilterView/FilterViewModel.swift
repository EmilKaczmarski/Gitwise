//
//  FilterViewModel.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 05/06/2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol FilterViewModelProtocol {
    var filterSectionsDriver: Driver<[FilterSectionModel]> { get }
    var applyFilters: Observable<[FilterSectionModel]> { get }
    var saveTrigger: PublishRelay<Void> { get }
}

final class FilterViewModel: FilterViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let filterSectionsTrigger = BehaviorRelay<[FilterSectionModel]>(value: [])
    
    var applyFilters: Observable<[FilterSectionModel]> {
        saveTrigger
            .compactMap { [weak self] in
                self?.filterSectionsTrigger.value
            }
    }
    
    let saveTrigger = PublishRelay<Void>()
    
    init(filterSections: [FilterSectionModel] = [Section.repository.model,
                                                 Section.sort.model]) {
        filterSectionsTrigger.accept(filterSections)
    }
    
    var filterSectionsDriver: Driver<[FilterSectionModel]> {
        filterSectionsTrigger
            .asDriver(onErrorDriveWith: .never())
    }
}

private extension FilterViewModel {
    
    enum Section {
        case repository
        case sort
        
        var model: FilterSectionModel {
            switch self {
                case .repository:
                    return .init(title: "Repository",
                                 options: self.options)
                case .sort:
                    return .init(title: "Sort",
                                 options: self.options)
            }
        }
        
        var options: FilterSectionModel.Options {
            switch self {
                case .repository:
                    return .init(left: .bitbucket,
                                 center: .none,
                                 right: .github)
                case .sort:
                    return .init(left: .ascending,
                                 center: .none,
                                 right: .descending)
            }
        }
    }
}

struct FilterSectionModel: Equatable {
    static func == (lhs: FilterSectionModel, rhs: FilterSectionModel) -> Bool {
        lhs.selectedOption.value == rhs.selectedOption.value
    }
    
    let title: String
    let options: Options
    var selectedOption = BehaviorRelay<Int>(value: 1)
    
    struct Options: Equatable {
        let left: FilterOption
        let center: FilterOption
        let right: FilterOption
    }
}

enum FilterOption {
    case github
    case bitbucket
    case none
    case ascending
    case descending
    
    var title: String? {
        switch self {
            case .github: return "Github"
            case .bitbucket: return "Bitbucket"
            case .none: return "None"
            case .ascending: return "Ascending"
            case .descending: return "Descending"
        }
    }
}
