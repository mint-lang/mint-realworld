async component Pages.Home {
  connect Stores.Articles exposing { status, params }
  connect Application exposing { user }

  connect Theme exposing { primary, primaryText }

  style banner {
    justify-content: center;
    flex-direction: column;
    background: #2c668e;
    align-items: center;
    text-align: center;
    display: flex;
    height: 300px;
    color: #EEE;
  }

  style layout {
    grid-template-columns: 1fr 300px;
    padding: 40px 0;
    grid-gap: 30px;
    display: grid;

    @media (max-width: 960px) {
      grid-template-columns: 1fr;
      padding: 15px 0;
    }
  }

  get banner : Html {
    case user {
      UserStatus.LoggedIn => Html.empty()

      UserStatus.LoggedOut =>
        <div::banner>
          <h1>"Conduit"</h1>

          <p>"A place to share your knowledge."</p>
        </div>
    }
  }

  fun render : Html {
    <div>
      banner

      <Container>
        <div::layout>
          <div>
            <Tabs>
              <Tab
                active={params.tag == "" && !params.feed}
                href="/articles?page=1"
                label="Global Feed"/>

              <If condition={user != UserStatus.LoggedOut}>
                <Tab
                  active={params.tag == "" && params.feed}
                  href="/feed?page=1"
                  label="Your Feed"/>
              </If>

              <If condition={params.tag != ""}>
                <Tab
                  label={"#" + String.toUpperCase(params.tag)}
                  active={true}/>
              </If>
            </Tabs>

            <Articles/>
          </div>

          <PopularTags/>
        </div>
      </Container>
    </div>
  }
}
