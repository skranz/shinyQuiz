
init.statement = function(sta, qu.ind=1) {
  restore.point("init.statement")
  types = substring(names(sta),1,1)
  yn.inds = which(types=="y" | types=="n")
  yn.ind = sample.int(length(yn.inds),1)

  st = list(qu.ind=qu.ind,yn.ind=yn.ind, yn = sta[[yn.ind]], type=types[[yn.ind]],
    all.yn=sta[yn.inds],types=types,expl=sta$e)
  st
}

statement.ui = function(st, check.fun=NULL, choices=c("true","false")) {
  restore.point("statement.ui")
  st = add.quiz.ui.id(st)

  ch = list("true","false")
  names(ch) = choices

  input = radioButtons(st$inputId, label="", choices=ch, selected=FALSE, inline=TRUE)
  ui = list(
    HTML(paste0("<hr>",st$yn)),
    input,
    bsButton(st$checkBtnId,label = "check",size = "extra-small"),
    uiOutput(st$explId)
  )
  buttonHandler(st$checkBtnId, check.statement.handler,st=st,check.fun=check.fun)
  setUI(st$explId,NULL)
  ui
}

check.statement.handler = function(st, check.fun,...) {
  restore.point("check.statement.handler")

  value = getInputValue(st$inputId)
  if (!(isTRUE(value=="false") | isTRUE(value=="true") )) {
    check.fun(answered=FALSE, correct=NA,qu=st,...)
    return()
  }
  if ( (value=="true" & st$type=="y") |
       (value=="false" & st$type=="n") )
  {
    check.fun(answered=TRUE,correct=TRUE, qu=st,...)
  } else {
    check.fun(answered=TRUE,correct=FALSE, qu=st,...)
  }
}
