component Container {
  property children : Array(Html) = []

  style base {
    max-width: 1140px;
    margin: 0 auto;
  }

  fun render : Html {
    <div::base>
      <{ children }>
    </div>
  }
}
