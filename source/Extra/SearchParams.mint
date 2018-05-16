module SearchParams {
  fun empty : SearchParams {
    `new URLSearchParams()`
  }

  fun append (key : String, value : String, params : SearchParams) : SearchParams {
    `
    (() => {
      params.append(key, value)
      return params
    })()
    `
  }

  fun toString (params : SearchParams) : String {
    `params.toString()`
  }
}
