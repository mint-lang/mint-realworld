component Layout.Outside {
  connect Theme exposing { primary }

  property children : Array(Html) = []
  property buttonText : String = ""
  property disabled : Bool = false
  property title : String = ""
  property onClick : Function(a) = () : Void => { void }

  style base {
    justify-content: center;
    flex-direction: column;
    align-items: center;
    display: flex;
    height: 100vh;
  }

  style form {
    flex-direction: column;
    max-width: 350px;
    display: flex;
    width: 100%;
  }

  style title {
    font-family: Expletus Sans;
    font-size: 50px;
    display: flex;
    height: 40px;
  }

  style brand {
    line-height: 50px;
    margin-left: 5px;
    height: 40px;
  }

  style button {
    background: {primary};
    border-radius: 2px;
    font-weight: bold;
    cursor: pointer;
    height: 40px;
    color: white;
    width: 100%;
    border: 0;

    &:disabled {
      opacity: 0.5;
    }
  }

  style hr {
    border: 0;
    border-top: 1px solid #EEE;
    margin: 20px 0;
  }

  style subtitle {
    text-align: center;
    margin-top: 40px;
    font-size: 20px;
  }

  fun handleClick (event : Html.Event) : a {
    onClick()
  }

  fun render : Html {
    <div::base>
      <div::title>
        <Logo size="40px"/>

        <span::brand>
          <{ "Conduit" }>
        </span>
      </div>

      <div::form>
        <div::subtitle>
          <{ title }>
        </div>

        <hr::hr/>

        <{ children }>

        <hr::hr/>

        <button::button
          onClick={handleClick}
          disabled={disabled}>

          <{ buttonText }>

        </button>
      </div>
    </div>
  }
}
