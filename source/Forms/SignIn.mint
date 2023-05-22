store Forms.SignIn {
  state status : Api.Status(User) = Api.Status::Initial

  state password : String = ""
  state email : String = ""

  fun setPassword (value : String) : Promise(Void) {
    next { password: value }
  }

  fun setEmail (value : String) : Promise(Void) {
    next { email: value }
  }

  fun reset : Promise(Void) {
    next
      {
        status: Api.Status::Initial,
        password: "",
        email: ""
      }
  }

  fun submit : Promise(Void) {
    await next { status: Api.Status::Loading }

    let body =
      encode {
        user:
          {
            password: password,
            email: email
          }
      }

    let newStatus =
      await Http.post("/users/login")
      |> Http.jsonBody(body)
      |> Api.send(User.fromResponse)

    await case newStatus {
      Api.Status::Ok(user) => Application.login(user)
      => next { status: newStatus }
    }
  }
}
