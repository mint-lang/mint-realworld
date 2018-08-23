component Pages.Home {
  connect Stores.Articles exposing { articles, status }
  connect Stores.User exposing { userStatus }

  connect Theme exposing { primary, primaryText }

  get articlePreviews : Array(Html) {
    articles
    |> Array.map(
      (article : Article) : Html => { <Article.Preview article={article}/> })
    |> Array.intersperse(<div::divider/>)
  }

  style base {

  }

  style divider {
    margin: 20px 0;
  }

  style banner {
    justify-content: center;
    flex-direction: column;
    background: {primary};
    color: {primaryText};
    align-items: center;
    text-align: center;
    display: flex;
    height: 300px;
  }

  style layout {
    grid-template-columns: 1fr 300px;
    display: grid;
    margin-top: 30px;
  }

  get banner : Html {
    case (userStatus) {
      Api.Status::Ok => Html.empty()

      =>
        <div::banner>
          <h1>
            <{ "Conduit" }>
          </h1>

          <p>
            <{ "A place to share your knowledge." }>
          </p>
        </div>
    }
  }

  fun render : Html {
    <div::base>
      <{ banner }>

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
