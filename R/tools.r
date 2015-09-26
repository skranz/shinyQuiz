copy.into.missing.fields = function(dest, source) {
  restore.point("copy.into.empty.fields")

  new.fields = setdiff(names(source), names(dest))
  dest[new.fields] = source[new.fields]
  dest
}


colored.html = function(txt, color="blue") {
  if (is.null(color)) return(txt)
  paste0("<font color='",color,"'>",txt,"</font>")
}
