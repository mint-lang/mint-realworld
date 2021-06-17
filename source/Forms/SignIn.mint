store Forms.SignIn {
  state status : Api.Status(User) = Api.Status::Initial

  state password : String = ""
  state email : String = ""

  fun setPassword (value : String) : Promise(Never, Void) {
    next { password = value }
  }

  fun setEmail (value : String) : Promise(Never, Void) {
    next { email = value }
  }

  fun reset : Promise(Never, Void) {
    next
      {
        status = Api.Status::Initial,
        password = "",
        email = ""
      }
  }

  fun submit : Promise(Never, Void) {
    sequence {
      next { status = Api.Status::Loading }

      body =
        encode {
          user =
            {
              password = password,
              email = email
            }
        }

      newStatus =
        Http.post("/users/login")
        |> Http.jsonBody(body)
        |> Api.send(User.fromResponse)

      case (newStatus) {
        Api.Status::Ok(user) => Application.login(user)
        => next { status = newStatus }
      }
    }
  }
}
