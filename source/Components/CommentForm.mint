component CommentForm {
  connect Forms.Comment exposing { submit, status, comment, setComment }
  connect Application exposing { user }
  connect Theme exposing { link }

  property article : Article = Article.empty()

  style form {
    flex-direction: column;
    display: flex;

    & > button {
      align-self: flex-end;
      width: auto;
    }
  }

  fun handleClick (event : Html.Event) : Promise(Never, Void) {
    submit(article.slug)
  }

  fun render : Html {
    case (user) {
      UserStatus::LoggedIn user =>
        <div::form>
          <Form.Field>
            <Textarea
              errors={Api.errorsOf("body", status)}
              placeholder="Write a comment..."
              name="Comment on this post:"
              onChange={setComment}
              value={comment}/>
          </Form.Field>

          <Button
            disabled={Api.isLoading(status)}
            onClick={handleClick}>

            <{ "Post Comment" }>

          </Button>
        </div>

      UserStatus::LoggedOut =>
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
