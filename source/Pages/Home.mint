component Tabs {
  property children : Array(Html) = []

  style base {
    margin-bottom: 20px;
    display: flex;
  }

  style separator {
    border-bottom: 2px solid #E9E9E9;
    flex: 1;
  }

  fun render : Html {
    <div::base>
      <{ children }>
      <div::separator/>
    </div>
  }
}

component Tab {
  connect Theme exposing { primary }

  property active : Bool = false
  property label : String = ""
  property href : String = ""

  style base {
    border-bottom: 2px solid #{borderColor};
    text-decoration: none;
    padding: 10px 20px;
    font-weight: bold;
    color: #{color};
  }

  get borderColor : String {
    if (active) {
      primary
    } else {
      "#E9E9E9"
    }
  }

  get color : String {
    if (active) {
      primary
    } else {
      "inherit"
    }
  }

  fun render : Html {
    <a::base href={href}>
      <{ label }>
    </a>
  }
}

component Pages.Home {
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
    case (user) {
      UserStatus::LoggedIn => Html.empty()

      UserStatus::LoggedOut =>
        <div::banner>
          <h1>"Conduit"</h1>

          <p>"A place to share your knowledge."</p>
        </div>
    }
  }

  fun render : Html {
    <div>
      <{ banner }>

      <Container>
        <div::layout>
          <div>
            <Tabs>
              <Tab
                active={params.tag == "" && !params.feed}
                href="/articles?page=1"
                label="Global Feed"/>

              <If condition={user != UserStatus::LoggedOut}>
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
