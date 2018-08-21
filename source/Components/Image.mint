enum Image.Status {
  Initial
  Invalid
  Ok
}

component Image {
  property borderRadius : String = "0"
  property height : String = "auto"
  property width : String = "auto"
  property src : String = ""

  state status : Image.Status = Image.Status::Initial

  fun componentDidMount : Promise(Never, Void) {
    sequence {
      status =
        load()

      next { status = status }
    }
  }

  fun load : Promise(Never, Image.Status) {
    `
    new Promise((resolve, reject) => {
      let image = new Image()
      image.onerror = () => {resolve(new $$Image_Status_Invalid)}
      image.onload = () => {resolve(new $$Image_Status_Ok)}
      image.src = this.src
    })
    `
  }

  style image {
    border-radius: {borderRadius};
    height: {height};
    display: block;
    width: {width};
  }

  style placeholder {
    border-radius: {borderRadius};
    background: #AAA;
    height: {height};
    width: {width};
  }

  fun render : Html {
    case (status) {
      Image.Status::Ok  => <img::image src={src}/>
      => <div::placeholder/>
    }
  }
}
