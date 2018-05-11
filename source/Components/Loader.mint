component Loader {
  property children : Array(Html) = []
  property overlay : Bool = false
  property loading : Bool = true

  style overlay {
    justify-content: center;
    align-items: center;
    display: flex;

    pointer-events: {pointerEvents};
    opacity: {opacity};
    position: absolute;
    transition: 320ms;
    background: #FFF;
    z-index: 10000;
    bottom: 0;
    right: 0;
    left: 0;
    top: 0;
  }

  style base {
    position: relative;
  }

  get pointerEvents : String {
    if (loading) {
      ""
    } else {
      "none"
    }
  }

  get opacity : Number {
    if (loading) {
      if (overlay) {
        0.5
      } else {
        1
      }
    } else {
      0
    }
  }

  get content : Html {
    if (overlay) {
      <div::overlay key="overlay">
        <{ "Loading..." }>
      </div>
    } else {
      <div>
        <{ "Loading..." }>
      </div>
    }
  }

  fun render : Html {
    <div::base>
      <{ children }>

      <{ content }>
    </div>
  }
}
