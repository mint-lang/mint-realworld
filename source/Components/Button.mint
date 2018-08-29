component Button {
  connect Theme exposing { primary }

  property onClick : Function(Html.Event, a) = (event : Html.Event) : Void => { void }
  property children : Array(Html) = []
  property disabled : Bool = false

  style base {
    background: {primary};
    border-radius: 1px;
    font-weight: bold;
    cursor: pointer;
    padding: 0 20px;
    height: 40px;
    color: white;
    width: 100%;
    border: 0;

    &:disabled {
      opacity: 0.5;
    }
  }

  fun render : Html {
    <button::base
      onClick={onClick}
      disabled={disabled}>

      <{ children }>

    </button>
  }
}
