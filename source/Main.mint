type SignInResponse {
  record : User,
  token : String
}

component Main {
  connect Application exposing { page }

  fun render : Html {
    case page {
      Initial => <></>
      Home(articles) => <Layout><Pages.Home articles={articles}/></Layout>
      Article => <Layout><Pages.Article/></Layout>
      Editor => <Layout><Pages.Editor/></Layout>
      Profile => <Layout><Pages.Profile/></Layout>
      Settings => <Layout><Pages.Settings/></Layout>
      NotFound => <Layout>"WTF"</Layout>
      SignUp => <Pages.SignUp/>
      SignIn => <Pages.SignIn/>
    }
  }
}
