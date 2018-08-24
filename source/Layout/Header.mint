component Header {
  connect Stores.User exposing { userStatus }

  style base {
    background: #222;
    color: #EEE;
  }

  style wrapper {
    align-items: center;
    display: flex;
    height: 56px;
  }

  style brand {
    font-family: Expletus Sans;
    text-decoration: none;
    letter-spacing: 1px;
    align-items: center;
    font-size: 28px;
    color: inherit;
    display: flex;
    height: 28px;
  }

  style brand-name {
    margin-left: 10px;
    line-height: 34px;
    display: block;
    height: 28px;
  }

  style links {
    text-transform: uppercase;
    margin-left: auto;
    font-weight: 600;
    font-size: 14px;
    display: flex;
  }

  style link {
    text-decoration: none;
    margin-left: 15px;
    color: inherit;
  }

  get links : Array(Html) {
    case (userStatus) {
      Api.Status::Error =>
        [
          <a::link href="/sign-in">
            <{ "Sign in" }>
          </a>,
          <a::link href="/sign-up">
            <{ "Sign up" }>
          </a>
        ]

      Api.Status::Ok =>
        [
          <a::link href="/new">
            <{ " New Post" }>
          </a>,
          <a::link href="">
            <{ " Settings" }>
          </a>,
          <a::link href="/logout">
            <{ "Sign out" }>
          </a>
        ]

      => [<Loader color="white"/>]
    }
  }

  fun render : Html {
    <div::base>
      <Container>
        <div::wrapper>
          <a::brand href="/">
            <Logo/>

            <span::brand-name>
              <{ "Conduit" }>
            </span>
          </a>

          <div::links>
            <{ links }>
          </div>
        </div>
      </Container>
    </div>
  }
}
