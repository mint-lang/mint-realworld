component Status {
  property status : Api.Status = Api.Status::Ok
  property children : Array(Html) = []
  property message : String = ""

  style base {
    position: relative;
  }

  style loader {
    position: absolute;
    z-index: 1000;
    bottom: 0;
    right: 0;
    left: 0;
    top: 0;

    background: rgba(255,255,255,0.8);
    transition-delay: 320ms;
    transition: 320ms;

    pointer-events: {pointerEvents};
    opacity: {opacity};

    justify-content: center;
    align-items: center;
    display: flex;
  }

  get pointerEvents : String {
    if (isLoading) {
      ""
    } else {
      "none"
    }
  }

  get opacity : Number {
    if (isLoading) {
      1
    } else {
      0
    }
  }

  get isLoading : Bool {
    case (status) {
      Api.Status::Reloading => true
      Api.Status::Loading => true
      => false
    }
  }

  fun render : Html {
    case (status) {
      Api.Status::Error =>
        <div>
          <{ message }>
        </div>

      Api.Status::Ok =>
        <div>
          <{ children }>
        </div>

      Api.Status::Loading =>
        <div>
          <{ "Loading..." }>
        </div>

      Api.Status::Reloading =>
        <div::base>
          <div::loader>
            <{ "Loading..." }>
          </div>

          <{ children }>
        </div>

      Api.Status::Initial => <div/>
    }
  }
}
