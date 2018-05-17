store Stores.Forms.Comment {
  property value : String = ""

  fun setValue (value : String) : Void {
    next { state | value = value }
  }
}

component Forms.Comment {
  connect Stores.Forms.Comment exposing { value, setValue }

  style base {

  }

  style textarea {
    border: 1px solid #EEE;
    font-family: inherit;
    border-bottom: none;
    resize: vertical;
    display: block;
    padding: 15px;
    width: 100%;
  }

  fun handleChange (event : Html.Event) : Void {
    event.target
    |> Dom.getValue()
    |> setValue()
  }

  fun render : Html {
    <div::base>
      <textarea::textarea
        placeholder="Write a comment..."
        onInput={handleChange}
        value={value}/>
    </div>
  }
}
