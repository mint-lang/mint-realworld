component Forms.Comment {
  connect Stores.Comments exposing { post, reload, slug, postStatus }
  connect Stores.User exposing { userStatus }

  connect Theme exposing { link }

  state value : String = ""

  style form {
    flex-direction: column;
    display: flex;

    & > button {
      align-self: flex-end;
      width: auto;
    }
  }

  fun clearValue : Promise(Never, Void) {
    next { value = "" }
  }

  fun handleChange (value : String) : Promise(Never, Void) {
    next { value = value }
  }

  fun handleClick (event : Html.Event) : Promise(Never, Void) {
    sequence {
      post(value)

      case (postStatus) {
        Api.Status::Ok =>
          parallel {
            clearValue()
            reload()
          }

        => Promise.never()
      }
    }
  }

  fun render : Html {
    case (userStatus) {
      Api.Status::Ok user =>
        <div::form>
          <Form.Field>
            <Textarea
              errors={Api.errorsOf("body", postStatus)}
              placeholder="Write a comment..."
              name="Comment on this post:"
              onChange={handleChange}
              value={value}/>
          </Form.Field>

          <Button
            onClick={handleClick}
            disabled={Api.isLoading(postStatus)}>

            <{ "Post Comment" }>

          </Button>
        </div>

      =>
        <div>
          <a href="/sign-in">
            <{ "Sign in" }>
          </a>

          <span>
            <{ "or" }>
          </span>

          <a href="/sign-up">
            <{ "sign up" }>
          </a>

          <span>
            <{ "to add comments on this article." }>
          </span>
        </div>
    }
  }
}
