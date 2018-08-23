component Title {
  property children : Array(Html) = []

  style base {
    font-family: Expletus Sans;
    font-size: 50px;
  }

  fun render : Html {
    <div::base>
      <{ children }>
    </div>
  }
}
