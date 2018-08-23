component Layout {
  property children : Array(Html) = []

  style base {
    flex-direction: column;
    min-height: 100vh;
    display: flex;
  }

  style content {
    flex: 1;
  }

  fun render : Html {
    <div::base>
      <Header/>

      <div::content>
        <{ children }>
      </div>

      <Footer/>
    </div>
  }
}
