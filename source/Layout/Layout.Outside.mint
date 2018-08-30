component Layout.Outside {
  connect Theme exposing { primary }

  property onClick : Function(a) = () : Void => { void }
  property children : Array(Html) = []
  property buttonText : String = ""
  property disabled : Bool = false
  property title : String = ""

  style base {
    background: radial-gradient(circle, farthest-corner, #FFF, #f5f5f5);
    justify-content: center;
    flex-direction: column;
    align-items: center;
    display: flex;
    height: 100vh;
  }

  style form {
    flex-direction: column;
    max-width: 400px;
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

        <Button
          onClick={handleClick}
          disabled={disabled}>

          <{ buttonText }>

        </Button>
      </div>
    </div>
  }
}