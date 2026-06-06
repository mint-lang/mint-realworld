async component Pages.SignUp {
  state status : Api.Status(SignInResponse) = Api.Status.Initial
  state confirmation : String = ""
  state username : String = ""
  state password : String = ""
  state email : String = ""

  fun submit : Promise(Void) {
    await next { status: Api.Status.Loading }

    let request =
      Http.post("/collections/users/records")
      |> Http.jsonBody(
        encode {
          passwordConfirm: confirmation,
          emailVisibility: true,
          password: password,
          username: username,
          email: email
        })
      |> Api.send(decode as User)

    let status =
      await request

    case status {
      Ok => next { status: await Api.signIn(email, password) }
      => next { status: Api.cast(status, Maybe.Nothing) }
    }
  }

  fun render : Html {
    let disabled =
      Api.isLoading(status)

    let buttonText =
      if disabled {
        "Loading..."
      } else {
        "Sign Up"
      }

    <Layout.Outside
      buttonText={buttonText}
      disabled={disabled}
      onClick={submit}
      title="Sign Up"
    >
      <Form>
        Api.globalErrors(status)

        <Form.Field>
          <Input
            errors={Api.errorsOf("username", status)}
            placeholder="realworld"
            onChange={-> username}
            disabled={disabled}
            value={username}
            name="Username"
          />
        </Form.Field>

        <Form.Field>
          <Input
            errors={Api.errorsOf("email", status)}
            placeholder="demo@realworld.io"
            onChange={-> email}
            disabled={disabled}
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

        <Form.Field>
          <Input
            errors={Api.errorsOf("password", status)}
            onChange={-> confirmation}
            placeholder="********"
            disabled={disabled}
            value={confirmation}
            type="password"
            name="confirmation"
          />
        </Form.Field>
      </Form>
    </Layout.Outside>
  }
}
