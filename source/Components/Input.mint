component Textarea {
  connect Theme exposing { primary }

  property onChange : Function(String, Promise(Void)) =
    (value : String) : Promise(Void) { next { } }

  property errors : Array(String) = []
  property placeholder : String = ""
  property disabled : Bool = false
  property value : String = ""
  property name : String = ""
  property rows : String = ""

  style base {
    border: 2px solid #{borderColor};
    font-family: inherit;
    font-size: 14px;
    padding: 10px;
    resize: none;
    color: #333;
    margin: 0;
    flex: 1;

    &:focus {
      border-color: #{focusColor};
      outline: none;
    }
  }

  get borderColor : String {
    if (Array.isEmpty(errors)) {
      "#EEE"
    } else {
      "#f7b6b6"
    }
  }

  get focusColor : String {
    if (Array.isEmpty(errors)) {
      primary
    } else {
      "#e84848"
    }
  }

  fun handleInput (event : Html.Event) : a {
    onChange(Dom.getValue(event.target))
  }

  fun render : Html {
    <>
      <Label>
        <{ name }>
      </Label>

      <textarea::base
        placeholder={placeholder}
        onInput={handleInput}
        disabled={disabled}
        value={value}
        rows={rows}/>

      <Errors
        errors={errors}
        prefix={name}/>
    </>
  }
}

component Input {
  connect Theme exposing { primary }

  property onBlur : Function(Html.Event, Promise(Void)) = (value : Html.Event) : Promise(Void) { next { } }
  property onChange : Function(String, Promise(Void)) = (value : String) : Promise(Void) { next { } }
  property onEnter : Function(Promise(Void)) = () : Promise(Void) { next { } }
  property errors : Array(String) = []
  property placeholder : String = ""
  property disabled : Bool = false
  property type : String = "text"
  property value : String = ""
  property name : String = ""

  style base {
    border: 2px solid #{borderColor};
    font-family: inherit;
    font-size: 14px;
    padding: 10px;
    color: #333;

    &:focus {
      border-color: #{focusColor};
      outline: none;
    }
  }

  get borderColor : String {
    if (Array.isEmpty(errors)) {
      "#EEE"
    } else {
      "#f7b6b6"
    }
  }

  get focusColor : String {
    if (Array.isEmpty(errors)) {
      primary
    } else {
      "#e84848"
    }
  }

  fun handleInput (event : Html.Event) : a {
    onChange(Dom.getValue(event.target))
  }

  fun handleKeyDown (event : Html.Event) : a {
    case (event.keyCode) {
      13 =>
        {
          Html.Event.preventDefault(event)
          onEnter()
        }

      => Promise.never()
    }
  }

  fun render : Html {
    <>
      <Label>
        <{ name }>
      </Label>

      <input::base
        placeholder={placeholder}
        onKeyDown={handleKeyDown}
        onInput={handleInput}
        disabled={disabled}
        onBlur={onBlur}
        value={value}
        type={type}/>

      <Errors
        errors={errors}
        prefix={name}/>
    </>
  }
}

component Form {
  property onSubmit : Function(Promise(Void)) = Promise.never
  property children : Array(Html) = []

  style hidden {
    display: none;
  }

  fun handleSubmit (event : Html.Event) : Promise(Void) {
    Html.Event.preventDefault(event)
    onSubmit()
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

    > *:first-child {
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
