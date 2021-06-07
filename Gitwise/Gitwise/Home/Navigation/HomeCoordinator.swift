//
//  HomeCoordinator.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 02/06/2021.
//

import Foundation
import XCoordinator
import RxSwift
import RxCocoa

enum HomeRoute: Route {
    case repoList
    case repoDetails(RepositoryModel, UIImage?)
    case back
}

final class HomeCoordinator: NavigationCoordinator<HomeRoute> {
    init() {
        super.init(initialRoute: .repoList)
    }
    
    override func prepareTransition(for route: HomeRoute) -> NavigationTransition {
        switch route {
            case .repoList:
                let viewController = HomeListViewController()
                viewController.viewModel = HomeListViewModel(router: strongRouter)
                return .push(viewController, animation: .fade)
                
            case let .repoDetails(model, image):
                let viewController = HomeDetailsViewController()
                
                let sections: [HomeDetailsSection] = [.userName,
                                                      .repoName("Repository Name"),
                                                      .repoDescription("Description")]
                
                viewController.viewModel = HomeDetailsViewModel(router: strongRouter,
                                                                model: model,
                                                                sectionTypes: sections,
                                                                backgroundImage: image)
                return .push(viewController, animation: .fade)
                
            case .back:
                return .pop(animation: .fade)
        }
    }
}
