component Input {
  property onChange : Function(String, Void) = (value : String) : Void => { void }
  property disabled : Bool = false
  property value : String = ""
  property type : String = "text"

  style base {
    border: 1px solid #CCC;
    margin-bottom: 15px;
    border-radius: 2px;
    padding: 5px 10px;
    font-size: 20px;
  }

  fun handleInput (event : Html.Event) : Void {
    onChange(Dom.getValue(event.target))
  }

  fun render : Html {
    <input::base
      onInput={handleInput}
      disabled={disabled}
      value={value}
      type={type}/>
  }
}

component Pages.Login {
  connect Stores.User exposing { login, loginStatus }

  state password : String = ""
  state email : String = ""

  style hidden {
    display: none;
  }

  style form {
    flex-direction: column;
    display: flex;
  }

  style base {
    max-width: 500px;
    margin: 0 auto;
  }

  style label {
    font-weight: bold;
    font-size: 14px;
  }

  fun handleEmail (value : String) : Void {
    next { email = value }
  }

  fun handlePassword (value : String) : Void {
    next { password = value }
  }

  fun handleSubmit (event : Html.Event) : Void {
    do {
      Html.Event.preventDefault(event)
      login(email, password)
    }
  }

  get disabled : Bool {
    case (loginStatus) {
      Api.Status::Reloading => true
      Api.Status::Loading => true
      => false
    }
  }

  fun render : Html {
    <div::base>
      <h1>
        <{ "Sign in" }>
      </h1>

      <form::form
        onSubmit={handleSubmit}
        autocomplete="false">

        <input::hidden
          name="prevent_autofill"
          id="prevent_autofill"
          type="text"
          value=""/>

        <label::label>
          <{ "Email" }>
        </label>

        <Input
          onChange={handleEmail}
          disabled={disabled}
          value={email}/>

        <label::label>
          <{ "Password" }>
        </label>

        <Input
          onChange={handlePassword}
          disabled={disabled}
          value={password}
          type="password"/>

        <button disabled={disabled}>
          <{ "Sign in" }>
        </button>

      </form>
    </div>
  }
}
