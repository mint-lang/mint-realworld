store Forms.SignUp {
  state status : Api.Status(User) = Api.Status.Initial

  state username : String = ""
  state password : String = ""
  state email : String = ""

  fun setUsername (value : String) : Promise(Void) {
    next { username: value }
  }

  fun setPassword (value : String) : Promise(Void) {
    next { password: value }
  }

  fun setEmail (value : String) : Promise(Void) {
    next { email: value }
  }

  fun submit : Promise(Void) {
    await next { status: Api.Status.Loading }

    let body =
      encode { user: { username: username, password: password, email: email } }

    let newStatus =
      await (Http.post("/users")
      |> Http.jsonBody(body)
      |> Api.send(User.fromResponse))

    case newStatus {
      Api.Status.Ok(user) => Application.login(user)
      => next { status: newStatus }
    }
  }
}
