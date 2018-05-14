record Pages.Login.State {
  password : String,
  email : String
}

component Pages.Login {
  connect Stores.User exposing { login }

  state : Pages.Login.State {
    password = "",
    email = ""
  }

  style form {
    flex-direction: column;
    display: flex;
  }

  style base {
    max-width: 500px;
    margin: 0 auto;
  }

  style input {
    border: 1px solid #CCC;
    margin-bottom: 15px;
    border-radius: 2px;
    padding: 5px 10px;
    font-size: 20px;
  }

  style label {
    font-weight: bold;
    font-size: 14px;
  }

  fun handleEmail (event : Html.Event) : Void {
    next { state | email = Dom.getValue(event.target) }
  }

  fun handlePassword (event : Html.Event) : Void {
    next { state | password = Dom.getValue(event.target) }
  }

  fun handleSubmit (event : Html.Event) : Void {
    do {
      Html.Event.preventDefault(event)
      login(state.email, state.password)
    }
  }

  fun render : Html {
    <div::base>
      <h1>
        <{ "Sign in" }>
      </h1>

      <form::form onSubmit={handleSubmit}>
        <label::label>
          <{ "Email" }>
        </label>

        <input::input
          onInput={handleEmail}
          value={state.email}/>

        <label::label>
          <{ "Password" }>
        </label>

        <input::input
          onInput={handlePassword}
          value={state.password}
          type="password"/>

        <button>
          <{ "Sign in" }>
        </button>
      </form>
    </div>
  }
}
