import Quick
import Nimble
import Cuckoo
import RxTest
import RxSwift
@testable import PostsViewer

private var samplePosts: [Post] = [
    .init(id: 1, title: "title01", body: "body01"),
    .init(id: 2, title: "title02", body: "body02"),
    .init(id: 3, title: "title03", body: "body03")
]

final class PostListUseCaseDefaultSpec: QuickSpec {

    override func spec() {
        super.spec()

        describe("PostListUseCaseDefault") {
            var useCase: PostListUseCaseDefault!
            var localRepositoryRefresherMock: MockLocalRepositoryRefresher!
            var allPostsLocalRepositoryRxMock: MockAllPostsLocalRepositoryRx!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()

                localRepositoryRefresherMock = MockLocalRepositoryRefresher()
                stub(localRepositoryRefresherMock) {
                    when($0.refresh()).thenDoNothing()
                }
                allPostsLocalRepositoryRxMock = MockAllPostsLocalRepositoryRx()
                useCase = PostListUseCaseDefault(
                    localRepositoryRefresher: localRepositoryRefresherMock,
                    allPostsLocalRepository: allPostsLocalRepositoryRxMock
                )
            }

            describe("refresh") {
                beforeEach {
                    useCase.refresh()
                }
                it("must call localRepositoryRefresher's method") {
                    verify(localRepositoryRefresherMock, times(1)).refresh()
                }
            }

            describe("state stream") {
                var observer: TestableObserver<PostList.UseCaseState>!
                beforeEach {
                    observer = scheduler.createObserver(PostList.UseCaseState.self)
                }

                context("failing local repository state stream") {
                    beforeEach {
                        stub(localRepositoryRefresherMock) {
                            when($0.localRepositoryStateStartingWithReloading(on: any()))
                                .thenReturn(.error(FakeError()))
                        }

                        useCase.state(on: scheduler)
                            .subscribe(observer)
                            .disposed(by: disposeBag)
                    }
                    it("must fail") {
                        observer.events.map { $0.value }
                            .extractAndExpect(at: 0, to: beErrorEvent())
                    }
                }

                context("local repository state stream emits .loading(isPreviousDataAvailable: true)") {
                    beforeEach {
                        stub(localRepositoryRefresherMock) {
                            when($0.localRepositoryStateStartingWithReloading(on: any()))
                                .thenReturn(.just(.loading(isPreviousDataAvailable: true)))
                        }

                        useCase.state(on: scheduler)
                            .subscribe(observer)
                            .disposed(by: disposeBag)
                    }
                    it("must emit .reloading") {
                        expect(observer.events.map { $0.value })
                            .to(equal([.next(.reloading), .completed]))
                    }
                }

                context("local repository state stream emits .loading(isPreviousDataAvailable: false)") {
                    beforeEach {
                        stub(localRepositoryRefresherMock) {
                            when($0.localRepositoryStateStartingWithReloading(on: any()))
                                .thenReturn(.just(.loading(isPreviousDataAvailable: false)))
                        }

                        useCase.state(on: scheduler)
                            .subscribe(observer)
                            .disposed(by: disposeBag)
                    }
                    it("must emit .loadingFromScratch") {
                        expect(observer.events.map { $0.value })
                            .to(equal([.next(.loadingFromScratch), .completed]))
                    }
                }

                context("local repository state stream emits .failure(isPreviousDataAvailable: true)") {
                    beforeEach {
                        stub(localRepositoryRefresherMock) {
                            when($0.localRepositoryStateStartingWithReloading(on: any()))
                                .thenReturn(.just(.failure(isPreviousDataAvailable: true)))
                        }
                    }

                    context("failing all posts local repository") {
                        beforeEach {
                            stub(allPostsLocalRepositoryRxMock) {
                                when($0.allPosts.get).thenReturn(.error(FakeError()))
                            }

                            useCase.state(on: scheduler)
                                .subscribe(observer)
                                .disposed(by: disposeBag)
                        }
                        it("must fail") {
                            observer.events.map { $0.value }
                                .extractAndExpect(at: 0, to: beErrorEvent())
                        }
                    }

                    context("all posts local repository emits samplePosts") {
                        beforeEach {
                            stub(allPostsLocalRepositoryRxMock) {
                                when($0.allPosts.get).thenReturn(.just(samplePosts))
                            }

                            useCase.state(on: scheduler)
                                .subscribe(observer)
                                .disposed(by: disposeBag)
                        }
                        it("must emit .reloadingFailed(oldPosts: samplePosts)") {
                            expect(observer.events.map { $0.value }).to(equal([
                                .next(.reloadingFailed(oldPosts: samplePosts)),
                                .completed
                            ]))
                        }
                    }
                }

                context("local repository state stream emits .failure(isPreviousDataAvailable: false)") {
                    beforeEach {
                        stub(localRepositoryRefresherMock) {
                            when($0.localRepositoryStateStartingWithReloading(on: any()))
                                .thenReturn(.just(.failure(isPreviousDataAvailable: false)))
                        }

                        useCase.state(on: scheduler)
                            .subscribe(observer)
                            .disposed(by: disposeBag)
                    }
                    it("must emit .loadingFromScratchFailed") {
                        expect(observer.events.map { $0.value })
                            .to(equal([.next(.loadingFromScratchFailed), .completed]))
                    }
                }

                context("local repository state stream emits .failureWithInconsistentState") {
                    beforeEach {
                        stub(localRepositoryRefresherMock) {
                            when($0.localRepositoryStateStartingWithReloading(on: any()))
                                .thenReturn(.just(.failureWithInconsistentState))
                        }

                        useCase.state(on: scheduler)
                            .subscribe(observer)
                            .disposed(by: disposeBag)
                    }
                    it("must emit .inconsistencyFailure") {
                        expect(observer.events.map { $0.value })
                            .to(equal([.next(.inconsistencyFailure), .completed]))
                    }
                }

                context("local repository state stream emits .ready(isLocalDataAvailable: true)") {
                    beforeEach {
                        stub(localRepositoryRefresherMock) {
                            when($0.localRepositoryStateStartingWithReloading(on: any()))
                                .thenReturn(.just(.ready(isLocalDataAvailable: true)))
                        }
                    }

                    context("failing all posts local repository") {
                        beforeEach {
                            stub(allPostsLocalRepositoryRxMock) {
                                when($0.allPosts.get).thenReturn(.error(FakeError()))
                            }

                            useCase.state(on: scheduler)
                                .subscribe(observer)
                                .disposed(by: disposeBag)
                        }
                        it("must fail") {
                            observer.events.map { $0.value }
                                .extractAndExpect(at: 0, to: beErrorEvent())
                        }
                    }

                    context("all posts local repository emits samplePosts") {
                        beforeEach {
                            stub(allPostsLocalRepositoryRxMock) {
                                when($0.allPosts.get).thenReturn(.just(samplePosts))
                            }

                            useCase.state(on: scheduler)
                                .subscribe(observer)
                                .disposed(by: disposeBag)
                        }
                        it("must emit .ready(posts: samplePosts)") {
                            expect(observer.events.map { $0.value }).to(equal([
                                .next(.ready(posts: samplePosts)),
                                .completed
                            ]))
                        }
                    }
                }

                context("local repository state stream emits .ready(isLocalDataAvailable: false)") {
                    beforeEach {
                        stub(localRepositoryRefresherMock) {
                            when($0.localRepositoryStateStartingWithReloading(on: any()))
                                .thenReturn(.just(.ready(isLocalDataAvailable: false)))
                        }

                        useCase.state(on: scheduler)
                            .subscribe(observer)
                            .disposed(by: disposeBag)
                    }
                    it("must emit .readyForLoadingFromScratch") {
                        expect(observer.events.map { $0.value })
                            .to(equal([.next(.readyForLoadingFromScratch), .completed]))
                    }
                }
            }
        }
    }
}
