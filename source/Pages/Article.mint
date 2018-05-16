component Pages.Article {
  connect Stores.Article exposing { article, status }

  style base {

  }

  style title {
    margin-bottom: 20px;
    font-size: 44px;
  }

  style header {
    background: #333;
    padding: 40px 0;
    color: white;
  }

  style content {
    margin-top: 50px;
  }

  style hr {
    border: 0;
    margin: 40px 0;
    border-top: 1px solid #DDD;
  }

  style spacer {
    height: 20px;
  }

  fun render : Html {
    <Status status={status}>
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
          </Container>
        </div>
      </div>
    </Status>
  }
}
