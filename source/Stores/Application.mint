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

    case (Storage.Local.get("user")) {
      Result::Err => next { user: UserStatus::LoggedOut }

      Result::Ok(data) =>
        case (Json.parse(data)) {
          Result::Err => next { user: UserStatus::LoggedOut }

          Result::Ok(object) =>
            case (decode object as User) {
              Result::Ok(currentUser) => next { user: UserStatus::LoggedIn(currentUser) }
              Result::Err => next { user: UserStatus::LoggedOut }
            }
        }
    }
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
