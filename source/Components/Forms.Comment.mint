store Stores.Forms.Comment {
  property value : String = ""

  fun setValue (value : String) : Void {
    next { state | value = value }
  }

  fun clearValue : Void {
    next { state | value = "" }
  }
}

component Forms.Comment {
  connect Stores.Forms.Comment exposing { value, setValue, clearValue }
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

  fun handleChange (event : Html.Event) : Void {
    event.target
    |> Dom.getValue()
    |> setValue()
  }

  fun handleClick (event : Html.Event) : Void {
    clearValue()
  }

  fun render : Html {
    <div>
      <textarea::textarea
        placeholder="Write a comment..."
        onInput={handleChange}
        value={value}/>

      <button::button onClick={handleClick}>
        <{ "Push me" }>
      </button>
    </div>
  }
}
