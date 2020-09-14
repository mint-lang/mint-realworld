component Main {
  connect Application exposing { page }

  fun render : Html {
    case (page) {
      Page::Initial => Html.empty()

      Page::Home =>
        <Layout>
          <Pages.Home/>
        </Layout>

      Page::Article =>
        <Layout>
          <Pages.Article/>
        </Layout>

      Page::Editor =>
        <Layout>
          <Pages.Editor/>
        </Layout>

      Page::Profile =>
        <Layout>
          <Pages.Profile/>
        </Layout>

      Page::Settings =>
        <Layout>
          <Pages.Settings/>
        </Layout>

      Page::NotFound =>
        <Layout>"WTF"</Layout>

      Page::SignUp => <Pages.SignUp/>
      Page::SignIn => <Pages.SignIn/>
    }
  }
}
