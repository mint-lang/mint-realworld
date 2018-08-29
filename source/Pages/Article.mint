component Pages.Article {
  connect Stores.Article exposing { article, status }

  connect Theme exposing { primary, primaryText }

  style base {

  }

  style title {
    margin-bottom: 20px;
    font-size: 44px;
  }

  style header {
    background: #EEE;
    padding: 40px 0;
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

  fun render : Html {
    <Status
      loadingMessage="Loading article..."
      status={status}>

      <div::base>
        <div::header>
          <Container>
            <div::title>
              <{ article.title }>
            </div>

            <Article.Profile article={article}/>
            <div::spacer/>
            <TagList tags={article.tags}/>
          </Container>
        </div>

        <div::content>
          <Container>
            <Markdown content={article.body}/>

            <hr::hr/>

            <Article.Comments/>

            <hr::hr/>

            <Forms.Comment/>
          </Container>
        </div>
      </div>

    </Status>
  }
}
