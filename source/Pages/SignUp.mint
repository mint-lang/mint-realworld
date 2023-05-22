component Pages.SignUp {
  connect Forms.SignUp exposing {
    setPassword,
    setUsername,
    setEmail,
    username,
    password,
    submit,
    status,
    email
  }

  get disabled : Bool {
    Api.isLoading(status)
  }

  get buttonText : String {
    if disabled {
      "Loading..."
    } else {
      "Sign Up"
    }
  }

  fun render : Html {
    <Layout.Outside
      buttonText={buttonText}
      disabled={disabled}
      onClick={submit}
      title="Sign Up">

      <Form>
        <GlobalErrors errors={Api.errorsOf("request", status)}/>

        <Form.Field>
          <Input
            errors={Api.errorsOf("username", status)}
            placeholder="realworld"
            onChange={setUsername}
            disabled={disabled}
            value={username}
            name="Username"/>
        </Form.Field>

        <Form.Field>
          <Input
            errors={Api.errorsOf("email", status)}
            placeholder="demo@realworld.io"
            onChange={setEmail}
            disabled={disabled}
            value={email}
            name="Email"/>
        </Form.Field>

        <Form.Field>
          <Input
            errors={Api.errorsOf("password", status)}
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
