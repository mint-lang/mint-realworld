enum Auth.Status {
  Unauthenticated
  Authenticated
  Initial
}

store Stores.User {
  state loginStatus : Api.Status = Api.Status::Initial
  state status : Auth.Status = Auth.Status::Initial

  state currentUser : Maybe(User) = Maybe.nothing()

  fun getCurrentUser : Void {
    do {
      user =
        Http.get(Api.endpoint() + "/user")
        |> Api.send(
          (object : Object) : Result(Object.Error, User) => {
            Object.Decode.field(
              "user",
              (input : Object) : Result(Object.Error, User) => { decode input as User },
              object)
          })

      next
        {
          status = Auth.Status::Authenticated,
          currentUser = Maybe.just(user)
        }
    } catch Api.Status => status {
      next { status = Auth.Status::Unauthenticated }
    }
  }

  fun logout : Void {
    do {
      Storage.Session.remove("token")
      resetStores()

      next
        {
          status = Auth.Status::Unauthenticated,
          currentUser = Maybe.nothing()
        }
    } catch Storage.Error => error {
      void
    }
  }

  fun resetStores : Void {
    do {
      Stores.Articles.reset()
      Stores.Article.reset()
      Stores.Comments.reset()
    }
  }

  fun login (email : String, password : String) : Void {
    do {
      next { loginStatus = Api.nextStatus(loginStatus) }

      userObject =
        with Object.Encode {
          object(
            [
              field("email", string(email)),
              field("password", string(password))
            ])
        }

      body =
        with Object.Encode {
          object([field("user", userObject)])
          |> Json.stringify()
        }

      user =
        Http.post(Api.endpoint() + "/users/login")
        |> Http.header("Content-Type", "application/json")
        |> Http.stringBody(body)
        |> Api.send(
          (object : Object) : Result(Object.Error, User) => {
            Object.Decode.field(
              "user",
              (input : Object) : Result(Object.Error, User) => { decode input as User },
              object)
          })

      Storage.Session.set("token", user.token)
      resetStores()

      next
        {
          status = Auth.Status::Authenticated,
          currentUser = Maybe.just(user),
          loginStatus = Api.Status::Ok
        }

      Window.navigate("/")
    } catch Api.Status => status {
      next { loginStatus = status }
    } catch Storage.Error => error {
      void
    }
  }
}
