component Pages.SignUp {
  connect Stores.User exposing { register, registerStatus }

  state username : String = ""
  state password : String = ""
  state email : String = ""

  fun handleUsername (value : String) : Promise(Never, Void) {
    next { username = value }
  }

  fun handlePassword (value : String) : Promise(Never, Void) {
    next { password = value }
  }

  fun handleEmail (value : String) : Promise(Never, Void) {
    next { email = value }
  }

  get disabled : Bool {
    Api.isLoading(registerStatus)
  }

  get buttonText : String {
    if (disabled) {
      "Loading..."
    } else {
      "Sign Up"
    }
  }

  fun handleSubmit : Promise(Never, Void) {
    register(username, email, password)
  }

  fun render : Html {
    <Layout.Outside
      buttonText={buttonText}
      onClick={handleSubmit}
      disabled={disabled}
      title="Sign Up">

      <Form>
        <GlobalErrors errors={Api.errorsOf("request", registerStatus)}/>

        <Form.Field>
          <Input
            errors={Api.errorsOf("username", registerStatus)}
            placeholder="realworld"
            onChange={handleUsername}
            disabled={disabled}
            value={username}
            name="Username"/>
        </Form.Field>

        <Form.Field>
          <Input
            errors={Api.errorsOf("email", registerStatus)}
            placeholder="demo@realworld.io"
            onChange={handleEmail}
            disabled={disabled}
            value={email}
            name="Email"/>
        </Form.Field>

        <Form.Field>
          <Input
            errors={Api.errorsOf("password", registerStatus)}
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
