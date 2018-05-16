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
    color: {primary};
    font-size: 18px;
  }

  style links {
    font-family: Source Sans Pro;
    margin-left: auto;
    display: flex;

    & > a {
      margin-left: 15px;
    }
  }

  get links : Array(Html) {
    case (status) {
      Auth.Status::Unauthenticated =>
        [
          <Link href="/login">
            <{ "Sign in" }>
          </Link>,
          <Link href="/register">
            <{ "Sign up" }>
          </Link>
        ]

      Auth.Status::Authenticated =>
        [
          <Link href="">
            <{ " New Post" }>
          </Link>,
          <Link href="">
            <{ " Settings" }>
          </Link>,
          <Link href="/logout">
            <{ "Sign out" }>
          </Link>
        ]

      => []
    }
  }

  fun render : Html {
    <div::base>
      <Container>
        <div::wrapper>
          <div::brand>
            <Link href="/">
              <{ "Conduit" }>
            </Link>
          </div>

          <div::links>
            <{ links }>
          </div>
        </div>
      </Container>
    </div>
  }
}
