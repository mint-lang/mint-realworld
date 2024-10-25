component Form.Field {
  property children : Array(Html) = []

  style base {
    flex-direction: column;
    display: flex;

    &:not(:last-child) {
      margin-bottom: 15px;
    }

    > *:first-child {
      margin-bottom: 5px;
    }
  }

  fun render : Html {
    <div::base>children</div>
  }
}
