store Stores.User {
  state registerStatus : Api.Status(User) = Api.Status::Initial

  state userStatus : Api.Status(User) = Api.Status::Initial

  fun updateUser (user : User) : Promise(Never, Void) {
    next { userStatus = Api.Status::Ok(user) }
  }

  fun getCurrentUser : Promise(Never, Void) {
    sequence {
      next { userStatus = Api.Status::Loading }

      userStatus =
        Http.get("/user")
        |> Api.send(User.fromResponse)

      next { userStatus = userStatus }
    }
  }

  fun logout : Promise(Never, Void) {
    sequence {
      Storage.Session.remove("token")
      resetStores()

      next { userStatus = Api.Status::Initial }
    } catch Storage.Error => error {
      void
    }
  }

  fun resetStores : Promise(Never, Void) {
    parallel {
      Stores.Articles.reset()
      Stores.Comments.reset()
      Stores.Article.reset()
    }
  }

  fun register (username : String, email : String, password : String) : Promise(Never, Void) {
    sequence {
      next { registerStatus = Api.Status::Loading }

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

      next { registerStatus = status }

      case (status) {
        Api.Status::Ok user => loginUser(user)
        => Promise.never()
      }
    }
  }

  fun loginUser (user : User) : Promise(Never, Void) {
    sequence {
      Storage.Session.set("token", user.token)

      resetStores()

      next { userStatus = Api.Status::Ok(user) }

      Window.navigate("/")
    } catch Storage.Error => error {
      void
    }
  }
}
