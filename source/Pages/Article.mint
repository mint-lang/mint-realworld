component Pages.Article {
  connect Stores.Article exposing { article, status }
  connect Theme exposing { primary, primaryText }
  connect Actions exposing { deleteArticle }
  connect Application exposing { user }

  style title {
    padding-right: {paddingRight};
    margin-bottom: 20px;
    font-size: 36px;
  }

  style header {
    padding: 40px 0 50px 0;
    background: #EEE;
    color: #333;

    @media (max-width: 960px) {
      padding: 15px 0;
    }

    /* Styles for the container. */
    & > * {
      position: relative;
    }
  }

  style content {
    padding-top: 50px;

    @media (max-width: 960px) {
      padding: 15px 0;
    }
  }

  style hr {
    border: 0;
    margin: 40px 0;
    border-top: 1px solid #EEE;

    @media (max-width: 960px) {
      margin: 20px 0;
    }
  }

  style buttons {
    margin-top: 10px;
    display: flex;
    width: 160px;

    & * + * {
      margin-left: 10px;
    }

    & > * {
      padding: 0 10px;
      height: 30px;
    }

    & svg {
      fill: currentColor;
      margin-right: 10px;
      height: 12px;
      width: 12px;
    }
  }

  style spacer {
    height: 20px;
  }

  fun handleDelete (event : Html.Event) : Promise(Never, Void) {
    deleteArticle(article.slug)
  }

  fun handleEdit (event : Html.Event) : Promise(Never, Void) {
    Window.navigate("/edit/" + article.slug)
  }

  get paddingRight : String {
    if (isMine) {
      "180px"
    } else {
      ""
    }
  }

  get isMine : Bool {
    case (user) {
      UserStatus::LoggedIn user => user.username == article.author.username
      => false
    }
  }

  fun render : Html {
    <Status
      message="There was an error loading the article."
      loadingMessage="Loading article..."
      status={status}>

      <div>
        <div::header>
          <Container>
            <div::title>
              <{ article.title }>
            </div>

            <Article.Info
              time={article.createdAt}
              author={article.author}/>

            <div::spacer/>

            <TagList tags={article.tags}/>

            <If condition={isMine}>
              <div::buttons>
                <Button onClick={handleEdit}>
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 24 24"
                    height="24"
                    width="24">

                    <path
                      d={
                        "M7.127 22.564l-7.126 1.436 1.438-7.125 5.688 5.689zm-4.2" \
                        "74-7.104l5.688 5.689 15.46-15.46-5.689-5.689-15.459 15.4" \
                        "6z"
                      }/>

                  </svg>

                  <{ "Edit" }>
                </Button>

                <Button onClick={handleDelete}>
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="24"
                    height="24"
                    viewBox="0 0 24 24">

                    <path
                      d={
                        "M3 6l3 18h12l3-18h-18zm19-4v2h-20v-2h5.711c.9 0 1.631-1." \
                        "099 1.631-2h5.316c0 .901.73 2 1.631 2h5.711z"
                      }/>

                  </svg>

                  <{ "Delete" }>
                </Button>
              </div>
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
