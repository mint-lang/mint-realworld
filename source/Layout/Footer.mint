component Footer {
  style hr {
    border: 0;
    border-top: 1px solid #EEE;
  }

  style container {
    text-align: center;
    padding: 40px 0;
    color: #999;

    & a {
      color: inherit;
    }

    @media (max-width: 960px) {
      padding-bottom: 20px;
      padding-top: 10px;
      font-size: 10px;
    }
  }

  fun render : Html {
    <div>
      <Container>
        <hr::hr/>

        <div::container>
          <span>
            "Implementation of "
          </span>

          <a href="https://realworld.io/">
            "https://realworld.io/"
          </a>

          <span>
            " in the Mint language."
          </span>

          <br/>

          <span>
            "Check out the source on Github: "
          </span>

          <a href="https://github.com/mint-lang/mint-realworld">
            "https://github.com/mint-lang/mint-realworld"
          </a>
        </div>
      </Container>
    </div>
  }
}
