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
    if Array.isEmpty(errors) {
      "#EEE"
    } else {
      "#f7b6b6"
    }
  }

  get focusColor : String {
    if Array.isEmpty(errors) {
      primary
    } else {
      "#e84848"
    }
  }

  fun handleInput (event : Html.Event) : a {
    onChange(Dom.getValue(event.target))
  }

  fun handleKeyDown (event : Html.Event) : a {
    if event.keyCode == Html.Event.ENTER {
      Html.Event.preventDefault(event)
      onEnter()
    }
  }

  fun render : Html {
    <>
      <Label>
        name
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
