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
