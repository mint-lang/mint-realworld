store Stores.User {
  property loginStatus : Api.Status = Api.Status::Initial
  property status : Auth.Status = Auth.Status::Initial
  property currentUser : Maybe(User) = Maybe.nothing()

  fun getCurrentUser : Void {
    do {
      user =
        Http.get(Api.endpoint() + "/user")
        |> Api.send(User.decode)

      next
        { state |
          currentUser = Maybe.just(user),
          status = Auth.Status::Authenticated
        }
    } catch Api.Status => status {
      next { state | status = Auth.Status::Unauthenticated }
    }
  }

  fun logout : Void {
    do {
      Storage.Session.remove("token")

      next
        { state |
          status = Auth.Status::Unauthenticated,
          currentUser = Maybe.nothing()
        }
    } catch Storage.Error => error {
      void
    }
  }

  fun login (email : String, password : String) : Void {
    do {
      next { state | loginStatus = Api.nextStatus(loginStatus) }

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
        |> Http.stringBody(body)
        |> Http.header("Content-Type", "application/json")
        |> Api.send(User.decode)

      Storage.Session.set("token", user.token)

      next
        { state |
          currentUser = Maybe.just(user),
          status = Auth.Status::Authenticated
        }

      Window.navigate("/")
    } catch Api.Status => status {
      next { state | loginStatus = status }
    } catch Storage.Error => error {
      void
    }
  }
}
