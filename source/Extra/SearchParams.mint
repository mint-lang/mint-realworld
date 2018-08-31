module SearchParams {
  fun empty : SearchParams {
    `new URLSearchParams()`
  }

  fun fromString (value : String) : SearchParams {
    `new URLSearchParams(value)`
  }

  fun get (name : String, params : SearchParams) : Maybe(String) {
    `
    (() => {
      let value = params.get(name)

      if (value === null ) {
        new Nothing()
      } else {
        new Just(value)
      }
    })()
    `
  }

  fun set (key : String, value : String, params : SearchParams) : SearchParams {
    `
    (() => {
      let newParams = new URLSearchParams(params.toString())
      newParams.set(key, value)
      return newParams
    })()
    `
  }

  fun append (key : String, value : String, params : SearchParams) : SearchParams {
    `
    (() => {
      let newParams = new URLSearchParams(params.toString())
      newParams.append(key, value)
      return newParams
    })()
    `
  }

  fun toString (params : SearchParams) : String {
    `params.toString()`
  }
}
