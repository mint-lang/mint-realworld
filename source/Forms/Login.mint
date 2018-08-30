store Forms.Login {
  state status : Api.Status(User) = Api.Status::Initial

  state password : String = ""
  state email : String = ""

  fun setEmail (value : String) : Promise(Never, Void) {
    next { email = value }
  }

  fun setPassword (value : String) : Promise(Never, Void) {
    next { password = value }
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

      status =
        Http.post("/users/login")
        |> Http.jsonBody(body)
        |> Api.send(User.fromResponse)

      next { status = status }

      case (status) {
        Api.Status::Ok user => Stores.User.loginUser(user)
        => Promise.never()
      }
    }
  }
}
