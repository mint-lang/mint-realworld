module SearchParams {
  fun appendNotBlank (params : SearchParams, key : String, value : String) : SearchParams {
    if String.isNotBlank(value) {
      SearchParams.append(params, key, value)
    } else {
      params
    }
  }
}
