component Layout.Form {
  property onSubmit : Function(a) = () : Void => { void }
  property buttonText : String = "Submit"
  property children : Array(Html) = []
  property errors : Array(String) = []
  property disabled : Bool = false
  property title : String = ""

  style title {
    border-bottom: 1px solid #EEE;
    padding-bottom: 10px;
    margin-bottom: 20px;
    font-weight: bold;
    font-size: 22px;
  }

  style hr {
    border: 0;
    border-top: 1px solid #EEE;
    margin: 20px 0;
  }

  style button {
    margin-left: auto;
    width: 150px;

    @media (max-width: 960px) {
      width: 100%;
    }
  }

  style base {
    padding: 30px 0;
  }

  fun render : Html {
    <div::base>
      <Container>
        <div::title>
          <{ title }>
        </div>

        <GlobalErrors errors={errors}/>

        <Form>
          <{ children }>
        </Form>

        <hr::hr/>

        <div::button>
          <Button
            disabled={disabled}
            onClick={(event : Html.Event) : Promise(Never, Void) => { onSubmit() }}>

            <{ buttonText }>

          </Button>
        </div>
      </Container>
    </div>
  }
}
