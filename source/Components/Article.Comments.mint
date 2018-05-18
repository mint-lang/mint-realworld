component Article.Comment {
  property comment : Comment = Comment.empty()

  style base {
    border: 1px solid #EEE;
    margin-bottom: 20px;
    border-radius: 2px;
  }

  style content {
    padding: 5px 15px;
  }

  style footer {
    align-items: center;
    padding: 10px 15px;
    background: #EEE;
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
        <Image
          src={comment.author.image}
          borderRadius="50%"
          height="20px"
          width="20px"/>

        <a>
          <{ comment.author.username }>
        </a>
      </div>
    </div>
  }
}

component Article.Comments {
  connect Stores.Comments exposing { comments, status }

  get content : Html {
    if (Array.isEmpty(comments)) {
      <div>
        <{ "This article does not have any comments yet." }>
      </div>
    } else {
      <div>
        <{
          Array.map(
            \comment : Comment => <Article.Comment comment={comment}/>,
            comments)
        }>
      </div>
    }
  }

  fun render : Html {
    <Status status={status}>
      <{ content }>
    </Status>
  }
}
