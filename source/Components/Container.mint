component Container {
  property children : Array(Html) = []

  style base {
    max-width: 960px;
    margin: 0 auto;

    @media (max-width: 960px) {
      padding: 0 15px;
    }
  }

  fun render : Html {
    <div::base>children</div>
  }
}
