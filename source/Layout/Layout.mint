component Layout {
  property children : Array(Html) = []

  style base {
    flex-direction: column;
    background: #f5f5f5;
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
        children
      </div>

      <Footer/>
    </div>
  }
}
