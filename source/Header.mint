component Header {
  connect Stores.User exposing { currentUser }

  style base {

  }

  style wrapper {
    align-items: center;
    max-width: 960px;
    margin: 0 auto;
    display: flex;
    height: 50px;
  }

  style links {
    margin-left: auto;
    display: flex;
  }

  get links : Array(Html) {
    if (Maybe.isJust(currentUser)) {
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
    } else {
      [
        <Link href="/login">
          <{ "Sign in" }>
        </Link>
      ]
    }
  }

  fun render : Html {
    <div::base>
      <div::wrapper>
        <Link href="/">
          <{ "Conduit" }>
        </Link>

        <div::links>
          <Link href="/">
            <{ "Home" }>
          </Link>
        </div>

        <{ links }>
      </div>
    </div>
  }
}
