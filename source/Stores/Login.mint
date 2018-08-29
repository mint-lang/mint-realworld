store Stores.Login {
  state status : Api.Status(User) = Api.Status::Initial

  fun reset : Promise(Never, Void) {
    next { status = Api.Status::Initial }
  }

  fun login (email : String, password : String) : Promise(Never, Void) {
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
