component Pages.Home {
  connect Stores.Articles exposing { articles, status }
  connect Theme exposing { primary, primaryText }

  get articlePreviews : Array(Html) {
    articles
    |> Array.map(
      \article : Article => <Article.Preview article={article}/>)
    |> Array.intersperse(<div::divider/>)
  }

  style base {

  }

  style divider {
    border-top: 1px solid #EEE;
    margin: 30px 0;
  }

  style banner {
    justify-content: center;
    flex-direction: column;
    background: {primary};
    color: {primaryText};
    align-items: center;
    text-align: center;
    display: flex;
    height: 170px;
  }

  style layout {
    grid-template-columns: 1fr 300px;
    display: grid;
    margin-top: 30px;
  }

  fun render : Html {
    <div::base>
      <div::banner>
        <h1>
          <{ "Conduit" }>
        </h1>

        <p>
          <{ "A place to share your knowledge." }>
        </p>
      </div>

      <Container>
        <div::layout>
          <div>
            <Status
              message="There was an error loading the articles."
              status={status}>

              <{ articlePreviews }>

            </Status>
          </div>

          <PopularTags/>
        </div>
      </Container>
    </div>
  }
}
