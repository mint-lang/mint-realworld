component Header {
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

          <Link href="">
            <{ " New Post" }>
          </Link>

          <Link href="">
            <{ " Settings" }>
          </Link>

          <Link href="">
            <{ "Sign up" }>
          </Link>
        </div>
      </div>
    </div>
  }
}
