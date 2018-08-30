component Article.Comment {
  property comment : Comment = Comment.empty()

  style base {
    margin-bottom: 20px;
    border-radius: 2px;
  }

  style content {

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
        <Image
          src={comment.author.image}
          borderRadius="3px"
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
      loadingMessage="Loading comments..."
      status={status}>

      <{ content }>

    </Status>
  }
}
