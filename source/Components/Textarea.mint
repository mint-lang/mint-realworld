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

  fun render : Html {
    <>
      <Label>
        name
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
