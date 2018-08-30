store Forms.SignUp {
  state status : Api.Status(User) = Api.Status::Initial

  state username : String = ""
  state password : String = ""
  state email : String = ""

  fun setUsername (value : String) : Promise(Never, Void) {
    next { username = value }
  }

  fun setPassword (value : String) : Promise(Never, Void) {
    next { password = value }
  }

  fun setEmail (value : String) : Promise(Never, Void) {
    next { email = value }
  }

  fun submit : Promise(Never, Void) {
    sequence {
      next { status = Api.Status::Loading }

      body =
        encode {
          user =
            {
              username = username,
              password = password,
              email = email
            }
        }

      status =
        Http.post("/users")
        |> Http.jsonBody(body)
        |> Api.send(User.fromResponse)

      next { status = status }

      case (status) {
        Api.Status::Ok user => Application.login(user)
        => Promise.never()
      }
    }
  }
}
