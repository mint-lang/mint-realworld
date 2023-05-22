component Form {
  property onSubmit : Function(Promise(Void)) = Promise.never
  property children : Array(Html) = []

  style hidden {
    display: none;
  }

  fun handleSubmit (event : Html.Event) : Promise(Void) {
    Html.Event.preventDefault(event)
    onSubmit()
  }

  fun render : Html {
    <form
      onSubmit={handleSubmit}
      autocomplete="false">

      <input::hidden
        name="prevent_autofill"
        id="prevent_autofill"
        type="text"
        value=""/>

      <{ children }>

    </form>
  }
}
