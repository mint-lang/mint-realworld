store Forms.Settings {
  state status : Api.Status(User) = Api.Status.Initial

  state username : String = ""
  state email : String = ""
  state image : String = ""
  state bio : String = ""

  fun setUsername (value : String) : Promise(Void) {
    next { username: value }
  }

  fun setImage (value : String) : Promise(Void) {
    next { image: value }
  }

  fun setEmail (value : String) : Promise(Void) {
    next { email: value }
  }

  fun setBio (value : String) : Promise(Void) {
    next { bio: value }
  }

  fun set (user : User) : Promise(Void) {
    next {
      status: Api.Status.Initial,
      image: Maybe.withDefault(user.image, ""),
      bio: Maybe.withDefault(user.bio, ""),
      username: user.username,
      email: user.email
    }
  }

  fun submit : Promise(Void) {
    await next { status: Api.Status.Loading }

    let body =
      encode { user: { username: username, image: image, email: email, bio: bio } }

    let newStatus =
      await (Http.put("/user")
      |> Http.jsonBody(body)
      |> Api.send(User.fromResponse))

    case newStatus {
      Api.Status.Ok(user) =>
        {
          await Application.setUser(user)
          await Window.navigate("/users/" + username)
        }

      => next { status: newStatus }
    }
  }
}
