component Pages.Article {
  connect Stores.Article exposing { article, status }
  connect Actions exposing { deleteArticle }
  connect Application exposing { user }

  connect Theme exposing { primary, primaryText }

  style title {
    margin-bottom: 20px;
    font-size: 44px;
  }

  style header {
    padding: 40px 0 50px 0;
    background: #EEE;
    color: #333;
  }

  style content {
    margin-top: 50px;
  }

  style hr {
    border: 0;
    margin: 40px 0;
    border-top: 1px solid #EEE;
  }

  style spacer {
    height: 20px;
  }

  fun handleDelete (event : Html.Event) : Promise(Never, Void) {
    deleteArticle(article.slug)
  }

  get isMine : Bool {
    case (user) {
      UserStatus::LoggedIn user => user.username == article.author.username
      => false
    }
  }

  fun render : Html {
    <Status
      message="The article cannot be found."
      loadingMessage="Loading article..."
      status={status}>

      <div>
        <div::header>
          <Container>
            <div::title>
              <{ article.title }>
            </div>

            <Article.Info article={article}/>
            <div::spacer/>
            <TagList tags={article.tags}/>

            <If condition={isMine}>
              <a href={"/edit/" + article.slug}>
                <{ "edit" }>
              </a>

              <a onClick={handleDelete}>
                <{ "delete" }>
              </a>
            </If>
          </Container>
        </div>

        <div::content>
          <Container>
            <Markdown content={article.body}/>

            <hr::hr/>

            <Article.Comments/>

            <hr::hr/>

            <CommentForm article={article}/>
          </Container>
        </div>
      </div>

    </Status>
  }
}
