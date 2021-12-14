module SearchParams {
  fun appendNotBlank (key : String, value : String, params : SearchParams) : SearchParams {
    if (String.isNotBlank(value)) {
      SearchParams.append(key, value, params)
    } else {
      params
    }
  }
}
