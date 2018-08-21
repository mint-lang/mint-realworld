component Input {
  property onChange : Function(String, a) = (value : String) : a => { void }
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

  fun handleInput (event : Html.Event) : a {
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

  fun handleEmail (value : String) : Promise(Never, Void) {
    next { email = value }
  }

  fun handlePassword (value : String) : Promise(Never, Void) {
    next { password = value }
  }

  fun handleSubmit (event : Html.Event) : Promise(Never, Void) {
    sequence {
      Html.Event.preventDefault(event)
      login(email, password)
    }
  }

  get disabled : Bool {
    case (loginStatus) {
      Api.Status::Reloading  => true
      Api.Status::Loading  => true
      => false
    }
  }

  get error : Html {
    case (loginStatus) {
      Api.Status::Error  =>
        <div>
          <{ "Invalid email or password!" }>
        </div>

      => Html.empty()
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

        <{ error }>

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
