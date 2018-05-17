record Image.State {
  status : Image.Status
}

enum Image.Status {
  Initial,
  Invalid,
  Ok
}

component Image {
  property borderRadius : String = "0"
  property height : String = "auto"
  property width : String = "auto"
  property src : String = ""

  state : Image.State { status = Image.Status::Initial }

  fun componentDidMount : Void {
    do {
      status =
        load()

      next { state | status = status }
    }
  }

  fun load : Promise(Never, Image.Status) {
    `
    new Promise((resolve, reject) => {
      let image = new Image()
      image.onerror = () => {resolve($Image_Status_Invalid)}
      image.onload = () => {resolve($Image_Status_Ok)}
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
    case (state.status) {
      Image.Status::Ok => <img::image src={src}/>
      => <div::placeholder/>
    }
  }
}
