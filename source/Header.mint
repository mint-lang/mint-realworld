component Header {
  connect Stores.User exposing { status }

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
    text-transform: uppercase;
    font-family: Righteous;
    text-decoration: none;
    letter-spacing: 1px;
    line-height: 24px;
    font-size: 24px;
    color: inherit;
    display: flex;
  }

  style brand-name {
    margin-left: 10px;
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
    case (status) {
      Auth.Status::Unauthenticated =>
        [
          <a::link href="/login">
            <{ "Sign in" }>
          </a>,
          <a::link href="/register">
            <{ "Sign up" }>
          </a>
        ]

      Auth.Status::Authenticated =>
        [
          <a::link href="">
            <{ " New Post" }>
          </a>,
          <a::link href="">
            <{ " Settings" }>
          </a>,
          <a::link href="/logout">
            <{ "Sign out" }>
          </a>
        ]

      =>
        [
          <a::link>
            <{ "Loading..." }>
          </a>
        ]
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
