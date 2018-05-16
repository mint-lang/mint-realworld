component Article.Comments {
  connect Stores.Comments exposing { comments, status }

  fun render : Html {
    <Status status={status}>
      <div>
        <{
          Array.map(
            \comment : Comment => <Markdown content={comment.body}/>,
            comments)
        }>
      </div>
    </Status>
  }
}
