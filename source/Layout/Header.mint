component Header {
  connect Application exposing { user }
  connect Theme exposing { primary }

  style base {
    background: #222;
    color: #EEE;
  }

  style wrapper {
    align-items: center;
    display: flex;
    height: 56px;

    @media (max-width: 960px) {
      display: block;
      height: auto;
    }
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

    &:focus {
      color: {primary};
      outline: none;
    }

    @media (max-width: 960px) {
      justify-content: center;
      padding: 10px 0;
      height: auto;
    }
  }

  style brand-name {
    margin-left: 10px;
    line-height: 34px;
    display: block;
    height: 28px;
  }

  style links {
    text-transform: uppercase;
    align-items: center;
    margin-left: auto;
    font-weight: 600;
    font-size: 14px;
    line-height: 1;

    grid-template-columns: repeat(5, min-content);
    grid-gap: 20px;
    display: grid;

    @media (max-width: 960px) {
      grid-template-columns: 1fr 1fr;
      border-top: 1px solid #333;
      padding: 10px 0;
      grid-gap: 10px;
      display: grid;
    }
  }

  style link {
    text-decoration: none;
    align-items: center;
    white-space: nowrap;
    color: inherit;
    padding: 3px 0;
    display: flex;

    & svg {
      fill: currentColor;
      margin-right: 6px;
      height: 16px;
      width: 16px;
    }

    &:hover {
      border-bottom: 1px solid #999;
    }

    &:focus {
      border-bottom: 1px solid {primary};
      color: {primary};
      outline: none;
    }

    @media (max-width: 960px) {
      text-align: left;
    }
  }

  style separator {
    border-left: 1px solid #999;
    height: 20px;

    @media (max-width: 960px) {
      display: none;
    }
  }

  get links : Html {
    case (user) {
      UserStatus::LoggedOut =>
        <>
          <a::link href="/sign-in">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              height="24"
              width="24">

              <path
                d={
                  "M8 9v-4l8 7-8 7v-4h-8v-6h8zm6-7c-1.787 0-3.46.474-4.911 " \
                  "1.295l.228.2 1.395 1.221c1.004-.456 2.115-.716 3.288-.71" \
                  "6 4.411 0 8 3.589 8 8s-3.589 8-8 8c-1.173 0-2.284-.26-3." \
                  "288-.715l-1.395 1.221-.228.2c1.451.82 3.124 1.294 4.911 " \
                  "1.294 5.522 0 10-4.477 10-10s-4.478-10-10-10z"
                }/>

            </svg>

            <{ "Sign in" }>
          </a>

          <a::link href="/sign-up">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              height="24"
              width="24">

              <path d="M8 24l3-9h-9l14-15-3 9h9l-14 15z"/>

            </svg>

            <{ "Sign up" }>
          </a>
        </>

      UserStatus::LoggedIn user =>
        <>
          <a::link href="/new">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24">

              <path
                d={
                  "M24.001 8.534l-11.103 11.218-5.898 1.248 1.361-5.784 11." \
                  "104-11.216 4.536 4.534zm-24 10.466l-.001 2h5v-2h-4.999z"
                }/>

            </svg>

            <{ " New Article" }>
          </a>

          <a::link href="/settings">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              height="24"
              width="24">

              <path
                d={
                  "M17 12.645v-2.289c-1.17-.417-1.907-.533-2.28-1.431-.373-" \
                  ".9.07-1.512.6-2.625l-1.618-1.619c-1.105.525-1.723.974-2." \
                  "626.6-.9-.374-1.017-1.117-1.431-2.281h-2.29c-.412 1.158-" \
                  ".53 1.907-1.431 2.28h-.001c-.9.374-1.51-.07-2.625-.6l-1." \
                  "617 1.619c.527 1.11.973 1.724.6 2.625-.375.901-1.123 1.0" \
                  "19-2.281 1.431v2.289c1.155.412 1.907.531 2.28 1.431.376." \
                  "908-.081 1.534-.6 2.625l1.618 1.619c1.107-.525 1.724-.97" \
                  "4 2.625-.6h.001c.9.373 1.018 1.118 1.431 2.28h2.289c.412" \
                  "-1.158.53-1.905 1.437-2.282h.001c.894-.372 1.501.071 2.6" \
                  "19.602l1.618-1.619c-.525-1.107-.974-1.723-.601-2.625.374" \
                  "-.899 1.126-1.019 2.282-1.43zm-8.5 1.689c-1.564 0-2.833-" \
                  "1.269-2.833-2.834s1.269-2.834 2.833-2.834 2.833 1.269 2." \
                  "833 2.834-1.269 2.834-2.833 2.834zm15.5 4.205v-1.077c-.5" \
                  "5-.196-.897-.251-1.073-.673-.176-.424.033-.711.282-1.236" \
                  "l-.762-.762c-.52.248-.811.458-1.235.283-.424-.175-.479-." \
                  "525-.674-1.073h-1.076c-.194.545-.25.897-.674 1.073-.424." \
                  "176-.711-.033-1.235-.283l-.762.762c.248.523.458.812.282 " \
                  "1.236-.176.424-.528.479-1.073.673v1.077c.544.193.897.25 " \
                  "1.073.673.177.427-.038.722-.282 1.236l.762.762c.521-.248" \
                  ".812-.458 1.235-.283.424.175.479.526.674 1.073h1.076c.19" \
                  "4-.545.25-.897.676-1.074h.001c.421-.175.706.034 1.232.28" \
                  "4l.762-.762c-.247-.521-.458-.812-.282-1.235s.529-.481 1." \
                  "073-.674zm-4 .794c-.736 0-1.333-.597-1.333-1.333s.597-1." \
                  "333 1.333-1.333 1.333.597 1.333 1.333-.597 1.333-1.333 1" \
                  ".333z"
                }/>

            </svg>

            <{ " Settings" }>
          </a>

          <a::link href="/logout">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              height="24"
              width="24">

              <path
                d={
                  "M16 9v-4l8 7-8 7v-4h-8v-6h8zm-2 10v-.083c-1.178.685-2.54" \
                  "2 1.083-4 1.083-4.411 0-8-3.589-8-8s3.589-8 8-8c1.458 0 " \
                  "2.822.398 4 1.083v-2.245c-1.226-.536-2.577-.838-4-.838-5" \
                  ".522 0-10 4.477-10 10s4.478 10 10 10c1.423 0 2.774-.302 " \
                  "4-.838v-2.162z"
                }/>

            </svg>

            <{ "Sign out" }>
          </a>

          <div::separator/>

          <a::link href={"/users/" + user.username}>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              height="24"
              width="24">

              <path
                d={
                  "M12 0c-6.627 0-12 5.373-12 12s5.373 12 12 12 12-5.373 12" \
                  "-12-5.373-12-12-12zm7.753 18.305c-.261-.586-.789-.991-1." \
                  "871-1.241-2.293-.529-4.428-.993-3.393-2.945 3.145-5.942." \
                  "833-9.119-2.489-9.119-3.388 0-5.644 3.299-2.489 9.119 1." \
                  "066 1.964-1.148 2.427-3.393 2.945-1.084.25-1.608.658-1.8" \
                  "67 1.246-1.405-1.723-2.251-3.919-2.251-6.31 0-5.514 4.48" \
                  "6-10 10-10s10 4.486 10 10c0 2.389-.845 4.583-2.247 6.305" \
                  "z"
                }/>

            </svg>

            <{ user.username }>
          </a>
        </>
    }
  }

  fun render : Html {
    <div::base>
      <Container>
        <div::wrapper>
          <a::brand href="/?page=1">
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
