component Pages.Home {
  connect Stores.Articles exposing { articles, status }
  connect Stores.User exposing { userStatus }

  connect Theme exposing { primary, primaryText }

  style base {

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
    padding: 40px 0;
    display: grid;
  }

  get banner : Html {
    case (userStatus) {
      Api.Status::Initial => Html.empty()
      Api.Status::Loading => Html.empty()
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
            <Articles status={status}/>
          </div>

          <PopularTags/>
        </div>
      </Container>
    </div>
  }
}
