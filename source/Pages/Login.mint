component Pages.Login {
  connect Stores.User exposing { login, loginStatus, userStatus }
  connect Theme exposing { primary }

  state password : String = ""
  state email : String = ""

  fun handleEmail (value : String) : Promise(Never, Void) {
    next { email = value }
  }

  fun handlePassword (value : String) : Promise(Never, Void) {
    next { password = value }
  }

  fun handleSubmit : Promise(Never, Void) {
    login(email, password)
  }

  get disabled : Bool {
    Api.isLoading(loginStatus)
  }

  get error : Html {
    case (loginStatus) {
      Api.Status::Error => <GlobalErrors errors={errors}/>

      => Html.empty()
    }
  } where {
    requestErrors =
      Api.errorsOf("request", loginStatus)

    errors =
      if (Array.isEmpty(requestErrors)) {
        ["Invalid email or password!"]
      } else {
        requestErrors
      }
  }

  get buttonText : String {
    if (disabled) {
      "Loading..."
    } else {
      "Sign In"
    }
  }

  fun render : Html {
    <Layout.Outside
      buttonText={buttonText}
      onClick={handleSubmit}
      disabled={disabled}
      title="Sign In">

      <Form>
        <{ error }>

        <Form.Field>
          <Input
            placeholder="demo@realworld.io"
            onChange={handleEmail}
            disabled={disabled}
            value={email}
            name="Email"/>
        </Form.Field>

        <Form.Field>
          <Input
            onChange={handlePassword}
            placeholder="********"
            disabled={disabled}
            value={password}
            type="password"
            name="Password"/>
        </Form.Field>
      </Form>

    </Layout.Outside>
  }
}
