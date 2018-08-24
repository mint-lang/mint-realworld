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

  get error : Html {
    case (registerStatus) {
      Api.Status::Error errors =>
        <div>
          <{ errors }>
        </div>

      => Html.empty()
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
        <{ error }>

        <Form.Field>
          <Label>
            <{ "Username" }>
          </Label>

          <Input
            placeholder="realworld"
            onChange={handleUsername}
            disabled={disabled}
            value={username}/>
        </Form.Field>

        <Form.Field>
          <Label>
            <{ "Email" }>
          </Label>

          <Input
            placeholder="demo@realworld.io"
            onChange={handleEmail}
            disabled={disabled}
            value={email}/>
        </Form.Field>

        <Form.Field>
          <Label>
            <{ "Password" }>
          </Label>

          <Input
            onChange={handlePassword}
            placeholder="********"
            disabled={disabled}
            value={password}
            type="password"/>
        </Form.Field>
      </Form>

    </Layout.Outside>
  }
}
