type UserStatus {
  LoggedIn(User, Maybe(String))
  LoggedOut
}

type Page {
  Settings
  NotFound
  Article
  Initial
  Profile
  Editor
  SignIn
  SignUp
  Home(articles : Api.Status(Articles), tags : Array(Array(String)))
}

store Application {
  state user : UserStatus = UserStatus.LoggedOut
  state page : Page = Page.Initial

  fun initializeWithPage (page : Page) : Promise(Void) {
    await setPage(page)
    await initialize()
  }

  fun initialize : Promise(Void) {
    Http.abortAll()

    let nextUser =
      {
        let Result.Ok(data) =
          Storage.Local.get("user") or return UserStatus.LoggedOut

        let Result.Ok(object) =
          Json.parse(data) or return UserStatus.LoggedOut

        let Result.Ok(currentUser) =
          decode object as User or return UserStatus.LoggedOut

        let token =
          Storage.Local.get("token")
          |> Result.toMaybe()

        UserStatus.LoggedIn(currentUser, token)
      }

    next { user: nextUser }
  }

  fun setUser (updatedUser : User) : Promise(Void) {
    next {
      user:
        case user {
          LoggedIn(_, token) => UserStatus.LoggedIn(updatedUser, token)
          LoggedOut => user
        }
    }
  }

  fun logout : Promise(Void) {
    Storage.Local.delete("user")

    await resetStores()
    await next { user: UserStatus.LoggedOut }
    await Window.navigate("/")
  }

  fun login (user : User, token : String) : Promise(Void) {
    Storage.Local.set("user", Json.stringify(encode user))

    await resetStores()
    await next { user: UserStatus.LoggedIn(user, Maybe.Just(token)) }
    await Window.navigate("/")
  }

  fun resetStores : Promise(Void) {
    await Stores.Comments.reset()
    await Stores.Article.reset()
  }

  fun setPage (page : Page) : Promise(Void) {
    next { page: page }
  }
}
