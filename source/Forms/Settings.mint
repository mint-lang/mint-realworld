store Forms.Settings {
  state status : Api.Status(User) = Api.Status::Initial

  state username : String = ""
  state email : String = ""
  state image : String = ""
  state bio : String = ""

  fun setUsername (value : String) : Promise(Never, Void) {
    next { username = value }
  }

  fun setImage (value : String) : Promise(Never, Void) {
    next { image = value }
  }

  fun setEmail (value : String) : Promise(Never, Void) {
    next { email = value }
  }

  fun setBio (value : String) : Promise(Never, Void) {
    next { bio = value }
  }

  fun set (user : User) : Promise(Never, Void) {
    next
      {
        status = Api.Status::Initial,
        image = Maybe.withDefault("", user.image),
        bio = Maybe.withDefault("", user.bio),
        username = user.username,
        email = user.email
      }
  }

  fun submit : Promise(Never, Void) {
    sequence {
      next { status = Api.Status::Loading }

      body =
        encode {
          user =
            {
              username = username,
              image = image,
              email = email,
              bio = bio
            }
        }

      newStatus =
        Http.put("/user")
        |> Http.jsonBody(body)
        |> Api.send(User.fromResponse)

      case (newStatus) {
        Api.Status::Ok(user) =>
          parallel {
            Application.setUser(user)
            Window.navigate("/users/" + username)
          }

        => next { status = newStatus }
      }
    }
  }
}
