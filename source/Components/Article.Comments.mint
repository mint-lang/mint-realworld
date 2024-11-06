component Article.Comments {
  connect Stores.Comments exposing { status }

  get content : Html {
    let comments =
      case status {
        Ok(comments) => comments
        => []
      }

    if Array.isEmpty(comments) {
      <div>"This article does not have any comments yet."</div>
    } else {
      <div>
        for comment of comments {
          <Article.Comment comment={comment}/>
        }
      </div>
    }
  }

  fun render : Html {
    <Status
      message="There was an error loading the comments."
      loadingMessage="Loading comments..."
      status={Api.toStatus(status)}
    >content</Status>
  }
}
