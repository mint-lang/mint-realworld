store Stores.Forms.Comment {
  state value : String = ""

  fun setValue (value : String) : Promise(Never, Void) {
    next { value = value }
  }

  fun clearValue : Promise(Never, Void) {
    next { value = "" }
  }
}

component Forms.Comment {
  connect Stores.Forms.Comment exposing { value, setValue, clearValue }
  connect Stores.Comments exposing { post, reload, slug }
  connect Stores.User exposing { userStatus }

  connect Theme exposing { link }

  style textarea {
    border: 1px solid #EEE;
    font-family: inherit;
    border-bottom: none;
    resize: vertical;
    display: block;
    padding: 15px;
    width: 100%;
  }

  style button {
    background-color: {link};

    &:hover {
      background-color: #a5b85b;
    }
  }

  fun handleChange (event : Html.Event) : Promise(Never, Void) {
    event.target
    |> Dom.getValue()
    |> setValue()
  }

  fun handleClick (event : Html.Event) : Promise(Never, Void) {
    sequence {
      post(value)
      clearValue()
      reload()
    }
  }

  fun render : Html {
    case (userStatus) {
      Api.Status::Ok user =>
        <div>
          <textarea::textarea
            placeholder="Write a comment..."
            onInput={handleChange}
            value={value}/>

          <button::button onClick={handleClick}>
            <{ "Push me" }>
          </button>
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
