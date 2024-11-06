component Label {
  property children : Array(Html) = []

  style base {
    font-weight: bold;
    font-size: 14px;
  }

  fun render : Html {
    <label::base>children</label>
  }
}
