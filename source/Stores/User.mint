enum Auth.Status {
  Unauthenticated,
  Authenticated,
  Initial
}

store Stores.User {
  property loginStatus : Api.Status = Api.Status::Initial
  property status : Auth.Status = Auth.Status::Initial

  property currentUser : Maybe(User) = Maybe.nothing()

  fun getCurrentUser : Void {
    do {
      user =
        Http.get(Api.endpoint() + "/user")
        |> Api.send(
          \object : Object =>
            Object.Decode.field(
              "user",
              \input : Object => decode input as User,
              object))

      next
        { state |
          status = Auth.Status::Authenticated,
          currentUser = Maybe.just(user)
        }
    } catch Api.Status => status {
      next { state | status = Auth.Status::Unauthenticated }
    }
  }

  fun logout : Void {
    do {
      Storage.Session.remove("token")
      resetStores()

      next
        { state |
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
        |> Http.header("Content-Type", "application/json")
        |> Http.stringBody(body)
        |> Api.send(
          \object : Object =>
            Object.Decode.field(
              "user",
              \input : Object => decode input as User,
              object))

      Storage.Session.set("token", user.token)
      resetStores()

      next
        { state |
          status = Auth.Status::Authenticated,
          currentUser = Maybe.just(user),
          loginStatus = Api.Status::Ok
        }

      Window.navigate("/")
    } catch Api.Status => status {
      next { state | loginStatus = status }
    } catch Storage.Error => error {
      void
    }
  }
}
