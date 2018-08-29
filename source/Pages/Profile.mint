component Profile {
  connect Stores.Profile exposing { status }

  style base {
    justify-content: center;
    flex-direction: column;
    align-items: center;
    background: white;
    display: flex;
    height: 400px;
  }

  get user : Author {
    Api.withDefault(Author.empty(), status)
  }

  fun render : Html {
    <div::base>
      <Status
        loadingMessage="Loading profile..."
        status={status}>

        <Image
          src={user.image}
          borderRadius="5px"
          width="150px"
          height="150px"/>

        <{ user.username }>
        <{ Maybe.withDefault("", user.bio) }>

      </Status>
    </div>
  }
}

component Pages.Profile {
  connect Stores.Articles exposing { status }

  style articles {
    padding: 40px 0;
  }

  fun render : Html {
    <div>
      <Profile/>

      <Container>
        <div::articles>
          <Articles status={status}/>
        </div>
      </Container>
    </div>
  }
}
