component Loader {
  property children : Array(Html) = []
  property loading : Bool = true

  fun render : Html {
    if (loading) {
      <div>
        <{ "Loading..." }>
      </div>
    } else {
      <div>
        <{ children }>
      </div>
    }
  }
}
