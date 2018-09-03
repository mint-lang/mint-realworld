component Article.Comments {
  connect Stores.Comments exposing { status }

  get content : Html {
    if (Array.isEmpty(comments)) {
      <div>
        <{ "This article does not have any comments yet." }>
      </div>
    } else {
      <div>
        <{
          Array.map(
            (comment : Comment) : Html => { <Article.Comment comment={comment}/> },
            comments)
        }>
      </div>
    }
  } where {
    comments =
      case (status) {
        Api.Status::Ok comments => comments
        => []
      }
  }

  fun render : Html {
    <Status
      message="There was an error loading the comments."
      loadingMessage="Loading comments..."
      status={status}>

      <{ content }>

    </Status>
  }
}
