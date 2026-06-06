async component Pages.SignIn {
  state status : Api.Status(SignInResponse) = Api.Status.Initial
  state password : String = ""
  state email : String = ""

  fun submit : Promise(Void) {
    await next { status: Api.Status.Loading }
    next { status: await Api.signIn(email, password) }
  }

  fun render : Html {
    let disabled =
      Api.isLoading(status)

    <Layout.Outside
      disabled={disabled}
      onClick={submit}
      title="Sign In"
      buttonText={
        if disabled {
          "Loading..."
        } else {
          "Sign In"
        }
      }
    >
      <Form>
        Api.globalErrors(status)

        <Form.Field>
          <Input
            errors={Api.errorsOf("identity", status)}
            placeholder="demo@realworld.io"
            disabled={disabled}
            onChange={-> email}
            value={email}
            name="Email"
          />
        </Form.Field>

        <Form.Field>
          <Input
            errors={Api.errorsOf("password", status)}
            onChange={-> password}
            placeholder="********"
            disabled={disabled}
            value={password}
            type="password"
            name="Password"
          />
        </Form.Field>
      </Form>
    </Layout.Outside>
  }
}
