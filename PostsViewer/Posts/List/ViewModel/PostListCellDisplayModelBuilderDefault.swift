import Foundation

struct PostListCellDisplayModelBuilderDefault: PostListCellDisplayModelBuilder {

    let fatalErrorCellDisplayModels: [PostList.CellDisplayModel] = [
        .noData(cellDisplayModel: .init(description:
            NSLocalizedString("Posts.List.Cell.Error.fatal", comment: "Fatal error")
        ))
    ]

    let errorLoadingFromScratchCellDisplayModels: [PostList.CellDisplayModel] = [
        .noData(cellDisplayModel: .init(description:
            NSLocalizedString(
                "Posts.List.Cell.Error.loadingFromScratch",
                comment: "Error loading from scratch"
            )
        ))
    ]

    func failedReloadCellDisplayModels(from oldPosts: [Post]) -> [PostList.CellDisplayModel] {
        let reloadingFailedDescription = NSLocalizedString(
            "Posts.List.Cell.reloadingFailed",
            comment: "Reloading failed"
        )
        return [.noData(cellDisplayModel: .init(description: reloadingFailedDescription))]
            + cellDisplayModels(from: oldPosts)
    }

    func cellDisplayModels(from posts: [Post]) -> [PostList.CellDisplayModel] {
        return posts
            .map { ($0.id, $0.title) }
            .map(PostList.CellDisplayModel.Post.init(id:title:))
            .map(PostList.CellDisplayModel.post(cellDisplayModel:))
    }
}
