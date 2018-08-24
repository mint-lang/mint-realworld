component Textarea {
  connect Theme exposing { primary }

  property onChange : Function(String, a) = (value : String) : a => { void }
  property placeholder : String = ""
  property disabled : Bool = false
  property value : String = ""
  property rows : String = ""

  style base {
    border: 1px solid #CCC;
    font-family: inherit;
    border-radius: 2px;
    font-size: 14px;
    padding: 10px;
    resize: none;
    margin: 0;
    flex: 1;

    &:focus {
      border-color: {primary};
      outline: none;
    }
  }

  fun handleInput (event : Html.Event) : a {
    onChange(Dom.getValue(event.target))
  }

  fun render : Html {
    <textarea::base
      placeholder={placeholder}
      onInput={handleInput}
      disabled={disabled}
      value={value}
      rows={rows}/>
  }
}

component Input {
  connect Theme exposing { primary }

  property onChange : Function(String, a) = (value : String) : a => { void }
  property placeholder : String = ""
  property disabled : Bool = false
  property type : String = "text"
  property value : String = ""

  style base {
    border: 1px solid #CCC;
    font-family: inherit;
    border-radius: 2px;
    font-size: 14px;
    padding: 10px;

    &:focus {
      border-color: {primary};
      outline: none;
    }
  }

  fun handleInput (event : Html.Event) : a {
    onChange(Dom.getValue(event.target))
  }

  fun render : Html {
    <input::base
      placeholder={placeholder}
      onInput={handleInput}
      disabled={disabled}
      value={value}
      type={type}/>
  }
}

component Form {
  property onSubmit : Function(a) = () : a => { void }
  property children : Array(Html) = []

  style hidden {
    display: none;
  }

  fun handleSubmit (event : Html.Event) : Promise(Never, Void) {
    sequence {
      Html.Event.preventDefault(event)
      onSubmit()
    }
  }

  fun render : Html {
    <form
      onSubmit={handleSubmit}
      autocomplete="false">

      <input::hidden
        name="prevent_autofill"
        id="prevent_autofill"
        type="text"
        value=""/>

      <{ children }>

    </form>
  }
}

component Form.Field {
  property children : Array(Html) = []

  style base {
    flex-direction: column;
    display: flex;

    &:not(:last-child) {
      margin-bottom: 15px;
    }

    & > *:first-child {
      margin-bottom: 5px;
    }
  }

  fun render : Html {
    <div::base>
      <{ children }>
    </div>
  }
}

component Label {
  property children : Array(Html) = []

  style base {
    font-weight: bold;
    font-size: 14px;
  }

  fun render : Html {
    <label::base>
      <{ children }>
    </label>
  }
}
