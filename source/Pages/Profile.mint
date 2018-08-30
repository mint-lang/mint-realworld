component Profile {
  connect Actions exposing { toggleUserFollow }
  connect Stores.Profile exposing { status }
  connect Application exposing { user }

  state loading : Bool = false

  style base {
    justify-content: center;
    flex-direction: column;
    align-items: center;
    background: white;
    min-height: 400px;
    padding: 80px 0;
    display: flex;
  }

  style username {
    font-weight: bold;
    margin-top: 30px;
    font-size: 26px;
  }

  style bio {
    margin-top: 20px;
    max-width: 500px;
    font-size: 14px;
  }

  style button {
    max-width: 200px;
    margin-top: 20px;
  }

  get profile : Author {
    Api.withDefault(Author.empty(), status)
  }

  get bio : Html {
    if (Maybe.isJust(profile.bio)) {
      <div::bio>
        <{ Maybe.withDefault("", profile.bio) }>
      </div>
    } else {
      Html.empty()
    }
  }

  get followText : String {
    if (loading) {
      "Loading..."
    } else {
      if (profile.following) {
        "Unfollow " + profile.username
      } else {
        "Follow " + profile.username
      }
    }
  }

  get followButton : Html {
    case (user) {
      UserStatus::LoggedOut => Html.empty()

      UserStatus::LoggedIn user =>
        if (user.username != profile.username) {
          <div::button>
            <Button onClick={handleFollow}>
              <{ followText }>
            </Button>
          </div>
        } else {
          Html.empty()
        }
    }
  }

  fun handleFollow (event : Html.Event) : Promise(Never, a) {
    sequence {
      next { loading = true }

      status =
        toggleUserFollow(profile)

      case (status) {
        Api.Status::Ok profile => Stores.Profile.setProfile(profile)
        => Promise.never()
      }

      next { loading = false }
    }
  }

  fun render : Html {
    <div::base>
      <Status
        loadingMessage="Loading profile..."
        status={status}>

        <Image
          src={profile.image}
          borderRadius="5px"
          width="150px"
          height="150px"/>

        <div::username>
          <{ profile.username }>
        </div>

        <{ bio }>
        <{ followButton }>

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
