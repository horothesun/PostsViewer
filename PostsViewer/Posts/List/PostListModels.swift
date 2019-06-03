enum PostList {

    enum UseCaseState: Equatable {
        case loadingFromScratch
        case reloading
        case loadingFromScratchFailed
        case reloadingFailed(oldPosts: [Post])
        case inconsistencyFailure
        case readyForLoadingFromScratch
        case ready(posts: [Post])
    }

    struct StaticInfo {
        let title: String
        let refreshButtonTitle: String
    }
    
    typealias PostId = Post.Id

    enum CellDisplayModel {
        struct NoData {
            let description: String
        }
        struct Post {
            let id: PostId
            let title: String
        }

        case noData(cellDisplayModel: NoData)
        case post(cellDisplayModel: Post)
    }
}
