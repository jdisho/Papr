// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import RxSwift
import Action
import UIKit


// MARK: AddToCollectionViewModel
protocol AddToCollectionViewModelInput {
  var cancelAction: CocoaAction { get }
  var navigateToCreateCollectionAction: CocoaAction { get }

}

protocol AddToCollectionViewModelOutput {
  var photoStream: Observable<Photo> { get }
  var collectionCellModelTypes: Observable<[PhotoCollectionCellModelType]> { get }
}

protocol AddToCollectionViewModelType {
  var input: AddToCollectionViewModelInput { get }
  var output: AddToCollectionViewModelOutput { get }
}

extension AddToCollectionViewModel: AddToCollectionViewModelType, AddToCollectionViewModelInput, AddToCollectionViewModelOutput {
  // MARK: Inputs & Outputs
  var input: AddToCollectionViewModelInput { return self }
  var output: AddToCollectionViewModelOutput { return self }
}



// MARK: AlertViewModel
protocol AlertViewModelInput {
  var closeAction: CocoaAction { get }
  var yesAction: CocoaAction { get }
  var noAction: CocoaAction { get }

}

protocol AlertViewModelOutput {
  var title: Observable<String> { get }
  var message: Observable<String> { get }
  var mode: Observable<AlertMode> { get }
  var yesObservable: Observable<Void> { get }
  var noObservable: Observable<Void> { get }
  var okObservable: Observable<Void> { get }
}

protocol AlertViewModelType {
  var input: AlertViewModelInput { get }
  var output: AlertViewModelOutput { get }
}

extension AlertViewModel: AlertViewModelType, AlertViewModelInput, AlertViewModelOutput {
  // MARK: Inputs & Outputs
  var input: AlertViewModelInput { return self }
  var output: AlertViewModelOutput { return self }
}



// MARK: CollectionCellViewModel
protocol CollectionCellViewModelInput {

}

protocol CollectionCellViewModelOutput {
  var photoCollection: Observable<PhotoCollection> { get }
}

protocol CollectionCellViewModelType {
  var input: CollectionCellViewModelInput { get }
  var output: CollectionCellViewModelOutput { get }
}

extension CollectionCellViewModel: CollectionCellViewModelType, CollectionCellViewModelInput, CollectionCellViewModelOutput {
  // MARK: Inputs & Outputs
  var input: CollectionCellViewModelInput { return self }
  var output: CollectionCellViewModelOutput { return self }
}



// MARK: CollectionsViewModel
protocol CollectionsViewModelInput {
  var loadMore: BehaviorSubject<Bool> { get }
  var collectionDetailsAction: Action<PhotoCollection, Void> { get }

  func refresh()
}

protocol CollectionsViewModelOutput {
  var isRefreshing: Observable<Bool>! { get }
  var collectionCellsModelType: Observable<[CollectionCellViewModelType]> { get }
}

protocol CollectionsViewModelType {
  var input: CollectionsViewModelInput { get }
  var output: CollectionsViewModelOutput { get }
}

extension CollectionsViewModel: CollectionsViewModelType, CollectionsViewModelInput, CollectionsViewModelOutput {
  // MARK: Inputs & Outputs
  var input: CollectionsViewModelInput { return self }
  var output: CollectionsViewModelOutput { return self }
}



// MARK: CreateCollectionViewModel
protocol CreateCollectionViewModelInput {
  var collectionName: BehaviorSubject<String> { get }
  var collectionDescription: BehaviorSubject<String> { get }
  var isPrivate: BehaviorSubject<Bool> { get }
  var cancelAction: CocoaAction { get }
  var saveAction: CocoaAction { get }

}

protocol CreateCollectionViewModelOutput {
  var saveButtonEnabled: Observable<Bool> { get }
}

protocol CreateCollectionViewModelType {
  var input: CreateCollectionViewModelInput { get }
  var output: CreateCollectionViewModelOutput { get }
}

extension CreateCollectionViewModel: CreateCollectionViewModelType, CreateCollectionViewModelInput, CreateCollectionViewModelOutput {
  // MARK: Inputs & Outputs
  var input: CreateCollectionViewModelInput { return self }
  var output: CreateCollectionViewModelOutput { return self }
}



// MARK: HomeViewCellModel
protocol HomeViewCellModelInput: PhotoViewModelInput {
  var photoDetailsAction: Action<Photo, Photo> { get }
  var userCollectionsAction: Action<Photo, Void> { get }

}

protocol HomeViewCellModelOutput: PhotoViewModelOutput {
  var userProfileImage: Observable<String>! { get }
  var fullname: Observable<String>! { get }
  var username: Observable<String>! { get }
  var smallPhoto: Observable<String>! { get }
  var fullPhoto: Observable<String>! { get }
  var updated: Observable<String>! { get }
}

protocol HomeViewCellModelType: PhotoViewModelType {
  var input: HomeViewCellModelInput { get }
  var output: HomeViewCellModelOutput { get }
}

extension HomeViewCellModel: HomeViewCellModelType, HomeViewCellModelInput, HomeViewCellModelOutput {
  // MARK: Inputs & Outputs
  var input: HomeViewCellModelInput { return self }
  var output: HomeViewCellModelOutput { return self }
}



// MARK: HomeViewModel
protocol HomeViewModelInput {
  var loadMore: BehaviorSubject<Bool> { get }
  var showCuratedPhotosAction: CocoaAction { get }
  var showLatestPhotosAction: CocoaAction { get }
  var orderByPopularityAction: CocoaAction { get }
  var orderByFrequencyAction: CocoaAction { get }
  var alertAction: Action<String, Void> { get }

  func refresh()
}

protocol HomeViewModelOutput {
  var photos: Observable<[Photo]>! { get }
  var isRefreshing: Observable<Bool>! { get }
  var curated: Observable<Bool>! { get }
  var orderBy: Observable<OrderBy>! { get }
  var navBarButtonName: Observable<NavBarTitle>! { get }
  var homeViewCellModelTypes: Observable<[HomeViewCellModelType]> { get }
}

protocol HomeViewModelType {
  var input: HomeViewModelInput { get }
  var output: HomeViewModelOutput { get }
}

extension HomeViewModel: HomeViewModelType, HomeViewModelInput, HomeViewModelOutput {
  // MARK: Inputs & Outputs
  var input: HomeViewModelInput { return self }
  var output: HomeViewModelOutput { return self }
}



// MARK: LoginViewModel
protocol LoginViewModelInput {
  var loginAction: CocoaAction { get }
  var closeAction: CocoaAction { get }

}

protocol LoginViewModelOutput {
  var buttonName: Observable<String> { get }
  var loginState: Observable<LoginState> { get }
  var randomPhotos: Observable<[Photo]> { get }
}

protocol LoginViewModelType {
  var input: LoginViewModelInput { get }
  var output: LoginViewModelOutput { get }
}

extension LoginViewModel: LoginViewModelType, LoginViewModelInput, LoginViewModelOutput {
  // MARK: Inputs & Outputs
  var input: LoginViewModelInput { return self }
  var output: LoginViewModelOutput { return self }
}



// MARK: PhotoCollectionCellModel
protocol PhotoCollectionCellModelInput {
  var addAction: CocoaAction { get }
  var removeAction: CocoaAction { get }

}

protocol PhotoCollectionCellModelOutput {
  var coverPhotoURL: Observable<String> { get }
  var collectionName: Observable<String> { get }
  var isCollectionPrivate: Observable<Bool> { get }
  var isPhotoInCollection: Observable<Bool> { get }
}

protocol PhotoCollectionCellModelType {
  var input: PhotoCollectionCellModelInput { get }
  var output: PhotoCollectionCellModelOutput { get }
}

extension PhotoCollectionCellModel: PhotoCollectionCellModelType, PhotoCollectionCellModelInput, PhotoCollectionCellModelOutput {
  // MARK: Inputs & Outputs
  var input: PhotoCollectionCellModelInput { return self }
  var output: PhotoCollectionCellModelOutput { return self }
}



// MARK: PhotoDetailsViewModel
protocol PhotoDetailsViewModelInput: PhotoViewModelInput {
  var dismissAction: CocoaAction { get }
  var moreAction: Action<[Any], Void> { get }

}

protocol PhotoDetailsViewModelOutput: PhotoViewModelOutput {
  var totalViews: Observable<String>! { get }
  var totalDownloads: Observable<String>! { get }
}

protocol PhotoDetailsViewModelType: PhotoViewModelType {
  var input: PhotoDetailsViewModelInput { get }
  var output: PhotoDetailsViewModelOutput { get }
}

extension PhotoDetailsViewModel: PhotoDetailsViewModelType, PhotoDetailsViewModelInput, PhotoDetailsViewModelOutput {
  // MARK: Inputs & Outputs
  var input: PhotoDetailsViewModelInput { return self }
  var output: PhotoDetailsViewModelOutput { return self }
}



// MARK: PhotoViewModel
protocol PhotoViewModelInput {
  var likePhotoAction: Action<Photo, Photo> { get }
  var unlikePhotoAction: Action<Photo, Photo> { get }
  var downloadPhotoAction: Action<Photo, String> { get }
  var writeImageToPhotosAlbumAction: Action<UIImage, Void> { get }
  var alertAction: Action<(title: String, message: String), Void> { get }
  var navigateToLogin: CocoaAction { get }

}

protocol PhotoViewModelOutput {
  var regularPhoto: Observable<String>! { get }
  var photoSizeCoef: Observable<Double>! { get }
  var totalLikes: Observable<String>! { get }
  var likedByUser: Observable<Bool>! { get }
  var photoStream: Observable<Photo>! { get }
  var service: PhotoServiceType { get }
  var sceneCoordinator: SceneCoordinatorType { get }
}

protocol PhotoViewModelType {
  var photoViewModelInput: PhotoViewModelInput { get }
  var photoViewModelOutput: PhotoViewModelOutput { get }
}

extension PhotoViewModel: PhotoViewModelType, PhotoViewModelInput, PhotoViewModelOutput {
  // MARK: Inputs & Outputs
  var photoViewModelInput: PhotoViewModelInput { return self }
  var photoViewModelOutput: PhotoViewModelOutput { return self }
}



// MARK: SearchCollectionsViewModel
protocol SearchCollectionsViewModelInput {

}

protocol SearchCollectionsViewModelOutput {
}

protocol SearchCollectionsViewModelType {
  var input: SearchCollectionsViewModelInput { get }
  var output: SearchCollectionsViewModelOutput { get }
}

extension SearchCollectionsViewModel: SearchCollectionsViewModelType, SearchCollectionsViewModelInput, SearchCollectionsViewModelOutput {
  // MARK: Inputs & Outputs
  var input: SearchCollectionsViewModelInput { return self }
  var output: SearchCollectionsViewModelOutput { return self }
}



// MARK: SearchPhotosCellModel
protocol SearchPhotosCellModelInput {

  func updateSize(width: Double, height: Double)
}

protocol SearchPhotosCellModelOutput {
  var smallPhotoURL: Observable<String> { get }
  var regularPhotoURL: Observable<String> { get }
  var photoSize: Observable<(width: Double, height: Double)> { get }
}

protocol SearchPhotosCellModelType {
  var input: SearchPhotosCellModelInput { get }
  var output: SearchPhotosCellModelOutput { get }
}

extension SearchPhotosCellModel: SearchPhotosCellModelType, SearchPhotosCellModelInput, SearchPhotosCellModelOutput {
  // MARK: Inputs & Outputs
  var input: SearchPhotosCellModelInput { return self }
  var output: SearchPhotosCellModelOutput { return self }
}



// MARK: SearchPhotosViewModel
protocol SearchPhotosViewModelInput {
  var loadMore: BehaviorSubject<Bool> { get }

}

protocol SearchPhotosViewModelOutput {
  var navTitle: Observable<String> { get }
  var searchPhotosCellModelType: Observable<[SearchPhotosCellModelType]> { get }
}

protocol SearchPhotosViewModelType {
  var input: SearchPhotosViewModelInput { get }
  var output: SearchPhotosViewModelOutput { get }
}

extension SearchPhotosViewModel: SearchPhotosViewModelType, SearchPhotosViewModelInput, SearchPhotosViewModelOutput {
  // MARK: Inputs & Outputs
  var input: SearchPhotosViewModelInput { return self }
  var output: SearchPhotosViewModelOutput { return self }
}



// MARK: SearchResultCellModel
protocol SearchResultCellModelInput {

}

protocol SearchResultCellModelOutput {
  var searchResult: Observable<SearchResult> { get }
}

protocol SearchResultCellModelType {
  var input: SearchResultCellModelInput { get }
  var output: SearchResultCellModelOutput { get }
}

extension SearchResultCellModel: SearchResultCellModelType, SearchResultCellModelInput, SearchResultCellModelOutput {
  // MARK: Inputs & Outputs
  var input: SearchResultCellModelInput { return self }
  var output: SearchResultCellModelOutput { return self }
}



// MARK: SearchUsersViewModel
protocol SearchUsersViewModelInput {
  var loadMore: BehaviorSubject<Bool> { get }

}

protocol SearchUsersViewModelOutput {
  var searchQuery: Observable<String> { get }
  var totalResults: Observable<Int> { get }
  var navTitle: Observable<String> { get }
  var usersViewModel: Observable<[UserCellModelType]> { get }
}

protocol SearchUsersViewModelType {
  var input: SearchUsersViewModelInput { get }
  var output: SearchUsersViewModelOutput { get }
}

extension SearchUsersViewModel: SearchUsersViewModelType, SearchUsersViewModelInput, SearchUsersViewModelOutput {
  // MARK: Inputs & Outputs
  var input: SearchUsersViewModelInput { return self }
  var output: SearchUsersViewModelOutput { return self }
}



// MARK: SearchViewModel
protocol SearchViewModelInput {
  var searchString: BehaviorSubject<String?> { get }
  var searchTrigger: InputSubject<Int>! { get }

}

protocol SearchViewModelOutput {
  var searchResultCellModel: Observable<[SearchResultCellModelType]> { get }
}

protocol SearchViewModelType {
  var input: SearchViewModelInput { get }
  var output: SearchViewModelOutput { get }
}

extension SearchViewModel: SearchViewModelType, SearchViewModelInput, SearchViewModelOutput {
  // MARK: Inputs & Outputs
  var input: SearchViewModelInput { return self }
  var output: SearchViewModelOutput { return self }
}



// MARK: UserCellModel
protocol UserCellModelInput {

}

protocol UserCellModelOutput {
  var fullName: Observable<NSAttributedString> { get }
  var profilePhotoURL: Observable<String> { get }
}

protocol UserCellModelType {
  var input: UserCellModelInput { get }
  var output: UserCellModelOutput { get }
}

extension UserCellModel: UserCellModelType, UserCellModelInput, UserCellModelOutput {
  // MARK: Inputs & Outputs
  var input: UserCellModelInput { return self }
  var output: UserCellModelOutput { return self }
}


