component Pages.Login {
  connect Stores.User exposing { login, loginStatus, userStatus }
  connect Theme exposing { primary }

  state password : String = ""
  state email : String = ""

  style base {
    justify-content: center;
    flex-direction: column;
    align-items: center;
    display: flex;
    height: 100vh;
  }

  style subtitle {
    text-align: center;
    margin-top: 40px;
    font-size: 20px;
  }

  style form {
    flex-direction: column;
    max-width: 350px;
    display: flex;
    width: 100%;
  }

  style title {
    font-family: Expletus Sans;
    font-size: 50px;
    display: flex;
    height: 40px;
  }

  style brand {
    line-height: 50px;
    margin-left: 5px;
    height: 40px;
  }

  style button {
    background: {primary};
    border-radius: 2px;
    font-weight: bold;
    cursor: pointer;
    height: 40px;
    color: white;
    width: 100%;
    border: 0;

    &:disabled {
      opacity: 0.5;
    }
  }

  style hr {
    border: 0;
    border-top: 1px solid #EEE;
    margin: 20px 0;
  }

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
      Api.Status::Error =>
        <div>
          <{ "Invalid email or password!" }>
        </div>

      => Html.empty()
    }
  }

  get buttonText : String {
    if (disabled) {
      "Loading..."
    } else {
      "Sign in"
    }
  }

  fun render : Html {
    <div::base>
      <div::title>
        <Logo size="40px"/>

        <span::brand>
          <{ "Conduit" }>
        </span>
      </div>

      <div::form>
        <div::subtitle>
          <{ "Sign In" }>
        </div>

        <hr::hr/>

        <Form onSubmit={handleSubmit}>
          <{ error }>

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

          <hr::hr/>

          <button::button disabled={disabled}>
            <{ buttonText }>
          </button>
        </Form>
      </div>
    </div>
  }
}
