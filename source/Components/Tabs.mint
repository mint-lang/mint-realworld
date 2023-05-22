component Tabs {
  property children : Array(Html) = []

  style base {
    margin-bottom: 20px;
    display: flex;
  }

  style separator {
    border-bottom: 2px solid #E9E9E9;
    flex: 1;
  }

  fun render : Html {
    <div::base>
      <{ children }>
      <div::separator/>
    </div>
  }
}
