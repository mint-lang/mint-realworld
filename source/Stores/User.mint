record LoginForm.User {
  password : String,
  email : String
}

record LoginForm {
  user : LoginForm.User
}

store Stores.User {
  state loginStatus : Api.Status(User) = Api.Status::Initial
  state userStatus : Api.Status(User) = Api.Status::Initial

  fun decodeUser (object : Object) : Result(Object.Error, User) {
    object
    |> Object.Decode.field(
      "user",
      (input : Object) : Result(Object.Error, User) => { decode input as User })
  }

  fun getCurrentUser : Promise(Never, Void) {
    sequence {
      next { userStatus = Api.Status::Loading }

      userStatus =
        Api.endpoint() + "/user"
        |> Http.get()
        |> Api.send(decodeUser)

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
    sequence {
      Stores.Articles.reset()
      Stores.Comments.reset()
      Stores.Article.reset()
    }
  }

  fun login (email : String, password : String) : Promise(Never, Void) {
    sequence {
      next { loginStatus = Api.Status::Loading }

      body =
        encode {
          user =
            {
              email = email,
              password = password
            }
        }

      loginStatus =
        Http.post(Api.endpoint() + "/users/login")
        |> Http.jsonBody(body)
        |> Api.send(decodeUser)

      case (loginStatus) {
        Api.Status::Ok user =>
          sequence {
            Storage.Session.set("token", user.token)

            resetStores()

            next
              {
                loginStatus = loginStatus,
                userStatus = loginStatus
              }

            Window.navigate("/")
          } catch Storage.Error => error {
            void
          }

        => next { loginStatus = loginStatus }
      }
    }
  }
}
