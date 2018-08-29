component Footer {
  style hr {
    border: 0;
    border-top: 1px solid #EEE;
  }

  style container {
    text-align: center;
    padding: 40px 0;
  }

  fun render : Html {
    <div>
      <Container>
        <hr::hr/>

        <div::container>
          <a
            href="/"
            class="logo-font">

            <{ "conduit" }>

          </a>

          <span class="attribution">
            <{ "An interactive learning project from" }>

            <a href="https://thinkster.io">
              <{ "Thinkster" }>
            </a>

            <{ ". Code &amp; design licensed under MIT." }>
          </span>
        </div>
      </Container>
    </div>
  }
}
