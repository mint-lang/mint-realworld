component Profile {
  connect Stores.Profile exposing { status, profile }
  connect Actions exposing { toggleUserFollow }
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

    @media (max-width: 960px) {
      padding: 40px 15px;
    }
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
    margin-top: 20px;
    line-height: 1;
    width: 180px;

    svg {
      fill: currentColor;
      margin-right: 5px;
      height: 10px;
      width: 10px;
    }
  }

  get bio : Html {
    if Maybe.isJust(profile.bio) {
      <div::bio>Maybe.withDefault(profile.bio, "")</div>
    } else {
      Html.empty()
    }
  }

  get followText : String {
    if loading {
      "Loading..."
    } else if profile.following or false {
      "Unfollow " + profile.username
    } else {
      "Follow " + profile.username
    }
  }

  get followIcon : Html {
    if loading {
      <></>
    } else if profile.following or false {
      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 24 24"
        height="24"
        width="24"
      ><path d="M0 9h24v6h-24z"/></svg>
    } else {
      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 24 24"
        height="24"
        width="24"
      ><path d="M24 9h-9v-9h-6v9h-9v6h9v9h6v-9h9z"/></svg>
    }
  }

  get followButton : Html {
    if let LoggedIn(user) = user {
      if user.username != profile.username {
        <div::button>
          <Button onClick={handleFollow} disabled={loading}>
            followIcon
            followText
          </Button>
        </div>
      }
    }
  }

  fun handleFollow (event : Html.Event) : Promise(Void) {
    await next { loading: true }

    let newStatus =
      await toggleUserFollow(profile)

    if let Ok(profile) = await newStatus {
      Stores.Profile.setProfile(profile)
    }

    await next { loading: false }
  }

  fun render : Html {
    <div::base>
      <Status
        message="There was an error loading the profile..."
        loadingMessage="Loading profile..."
        status={Api.toStatus(status)}
      >
        <Image
          src={profile.image}
          borderRadius="5px"
          width="150px"
          height="150px"
        />

        <div::username>profile.username</div>

        bio
        followButton
      </Status>
    </div>
  }
}
