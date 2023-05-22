enum UserStatus {
  LoggedIn(User)
  LoggedOut
}

enum Page {
  Settings
  NotFound
  Article
  Initial
  Profile
  Editor
  SignIn
  SignUp
  Home
}

store Application {
  state user : UserStatus = UserStatus::LoggedOut
  state page : Page = Page::Initial

  fun initializeWithPage (page : Page) : Promise(Void) {
    await setPage(page)
    await initialize()
  }

  fun initialize : Promise(Void) {
    Http.abortAll()

    let nextUser =
      {
        let Result::Ok(data) =
          Storage.Local.get("user") or return UserStatus::LoggedOut

        let Result::Ok(object) =
          Json.parse(data) or return UserStatus::LoggedOut

        let Result::Ok(currentUser) =
          decode object as User or return UserStatus::LoggedOut

        UserStatus::LoggedIn(currentUser)
      }

    next { user: nextUser }
  }

  fun setUser (user : User) : Promise(Void) {
    next { user: UserStatus::LoggedIn(user) }
  }

  fun logout : Promise(Void) {
    Storage.Local.delete("user")

    await resetStores()
    await next { user: UserStatus::LoggedOut }
    await Window.navigate("/")
  }

  fun login (user : User) : Promise(Void) {
    Storage.Local.set("user", Json.stringify(encode user))

    await resetStores()
    await next { user: UserStatus::LoggedIn(user) }
    await Window.navigate("/")
  }

  fun resetStores : Promise(Void) {
    await Stores.Articles.reset()
    await Stores.Comments.reset()
    await Stores.Article.reset()
  }

  fun setPage (page : Page) : Promise(Void) {
    next { page: page }
  }
}
