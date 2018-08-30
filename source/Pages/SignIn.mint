component Pages.SignIn {
  connect Forms.SignIn exposing { submit, status, setEmail, setPassword, email, password }

  connect Theme exposing { primary }

  get disabled : Bool {
    Api.isLoading(status)
  }

  get error : Html {
    case (status) {
      Api.Status::Error => <GlobalErrors errors={errors}/>
      => Html.empty()
    }
  } where {
    requestErrors =
      Api.errorsOf("request", status)

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
      disabled={disabled}
      onClick={submit}
      title="Sign In">

      <Form>
        <{ error }>

        <Form.Field>
          <Input
            placeholder="demo@realworld.io"
            onChange={setEmail}
            disabled={disabled}
            value={email}
            name="Email"/>
        </Form.Field>

        <Form.Field>
          <Input
            onChange={setPassword}
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
