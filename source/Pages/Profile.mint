component Pages.Profile {
  connect Stores.Articles exposing { params }
  connect Stores.Profile exposing { profile }

  style articles {
    padding: 40px 0;

    @media (max-width: 960px) {
      padding: 15px 0;
    }
  }

  fun render : Html {
    <div>
      <Profile/>

      <Container>
        <div::articles>
          <Tabs>
            <Tab
              href={"/users/" + profile.username}
              active={!params.favorited}
              label="Articles"/>

            <Tab
              href={"/users/" + profile.username + "/favorites"}
              label="Favorited Articles"
              active={params.favorited}/>
          </Tabs>

          <Articles/>
        </div>
      </Container>
    </div>
  }
}
