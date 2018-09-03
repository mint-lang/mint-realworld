component Article.Comment {
  property comment : Comment = Comment.empty()

  style base {
    background: #fafafa;
    margin-bottom: 20px;
    border-radius: 2px;
    padding: 15px;
  }

  style content {
    margin-bottom: 15px;
  }

  style footer {
    align-items: center;
    font-size: 12px;
    display: flex;

    & > * + * {
      margin-left: 10px;
    }
  }

  fun render : Html {
    <div::base>
      <div::content>
        <Markdown content={comment.body}/>
      </div>

      <div::footer>
        <Article.Info
          author={comment.author}
          time={comment.createdAt}/>
      </div>
    </div>
  }
}
