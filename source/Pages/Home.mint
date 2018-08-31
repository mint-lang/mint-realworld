component Pages.Home {
  connect Stores.Articles exposing { status }
  connect Application exposing { user }

  connect Theme exposing { primary, primaryText }

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
    grid-gap: 30px;
    display: grid;
  }

  get banner : Html {
    case (user) {
      UserStatus::LoggedIn => Html.empty()

      UserStatus::LoggedOut =>
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
    <div>
      <{ banner }>

      <Container>
        <div::layout>
          <div>
            <Articles/>
          </div>

          <PopularTags/>
        </div>
      </Container>
    </div>
  }
}
