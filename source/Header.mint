component Header {
  connect Stores.User exposing { status }
  connect Theme exposing { primary }

  style base {

  }

  style wrapper {
    align-items: center;
    display: flex;
    height: 56px;
  }

  style brand {
    font-family: Titillium Web;
    text-decoration: none;
    color: {primary};
    font-size: 18px;
  }

  style links {
    font-family: Source Sans Pro;
    margin-left: auto;
    display: flex;
  }

  style link {
    text-decoration: none;
    margin-left: 15px;
    color: {primary};
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

      => []
    }
  }

  fun render : Html {
    <div::base>
      <Container>
        <div::wrapper>
          <a::brand href="/">
            <{ "Conduit" }>
          </a>

          <div::links>
            <{ links }>
          </div>
        </div>
      </Container>
    </div>
  }
}
