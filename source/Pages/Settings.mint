async component Pages.Settings {
  connect Forms.Settings exposing {
    submit,
    email,
    image,
    username,
    bio,
    status,
    setEmail,
    setBio,
    setUsername,
    setImage
  }

  style grid {
    min-height: 242px;
    grid-gap: 20px;
    display: grid;

    grid-template-rows: min-content min-content 1fr;
    grid-template-columns: 1fr 1fr;

    grid-template-areas: "image bio"
                         "username bio"
                         "email bio";

    > *:nth-child(1) {
      grid-area: image;
    }

    > *:nth-child(2) {
      grid-area: username;
    }

    > *:nth-child(3) {
      grid-area: email;
    }

    > *:last-child {
      grid-area: bio;
    }

    @media (max-width: 960px) {
      grid-template-areas: "image" "username" "email" "bio";
      grid-template-columns: 1fr;
      grid-template-rows: auto;
      grid-gap: 15px;
    }
  }

  style cell {
    display: grid;
  }

  get disabled : Bool {
    Api.isLoading(status)
  }

  fun render : Html {
    <Layout.Form
      errors={Api.errorsOf("request", status)}
      onSubmit={submit}
      title="Settings">

      <div::grid>
        <div::cell>
          <Form.Field>
            <Input
              errors={Api.errorsOf("image", status)}
              placeholder="URL of profile picture"
              onChange={setImage}
              disabled={disabled}
              value={image}
              name="Image"/>
          </Form.Field>
        </div>

        <div::cell>
          <Form.Field>
            <Input
              errors={Api.errorsOf("username", status)}
              onChange={setUsername}
              placeholder=""
              disabled={disabled}
              value={username}
              name="Username"/>
          </Form.Field>
        </div>

        <div::cell>
          <Form.Field>
            <Input
              errors={Api.errorsOf("email", status)}
              onChange={setEmail}
              placeholder=""
              disabled={disabled}
              value={email}
              name="Email"/>
          </Form.Field>
        </div>

        <div::cell>
          <Form.Field>
            <Textarea
              errors={Api.errorsOf("bio", status)}
              onChange={setBio}
              placeholder=""
              disabled={disabled}
              value={bio}
              name="Bio"/>
          </Form.Field>
        </div>
      </div>

    </Layout.Form>
  }
}
