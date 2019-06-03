import Foundation

enum PostDetails {

    struct UseCaseResponse {
        let postTitle: String
        let postDescription: String
        let authorName: String
        let authorUsername: String
        let numberOfComments: Int
    }

    struct DisplayModel {
        let postTitle: String
        let postDescription: String
        let author: String
        let numberOfComments: String
    }
}
