
examples.quiz = function() {
    yaml = '
parts:
  - question: What is 20*20?
    choices:
        - 100
        - 200
        - 400*
        - 500
    multiple: FALSE
    success: Great, your answer is correct!
    failure: Try again.
  - question: State pi up to 2 digits
    answer: 3.14
    roundto: 0.01
  '

yaml = '
question: What is 20*20?
mc:
  - 100
  - 200
  - 400*
  - 500
success: Great, your answer is correct!
failure: Try again.
'

  app = eventsApp()

  qu = shinyQuiz(id="myquiz", yaml=yaml, quiz.handler=function(qu,solved,...) {
    cat("\nQuiz solved = ", solved)
  })
  app$ui = qu$ui
  app$ui = quiz.ui(qu, solution=TRUE)
  runEventsApp(app, launch.browser=rstudio::viewer)

}

quizDefaults = function(lang="en") {
  if (lang=="de") {
    list(
      sucess = "richtig!",
      failure= "leider falsch",
      success_color = "blue",
      failure_color = "red"
    )
  } else {
    list(
      sucess = "correct",
      failure= "not correct",
      success_color = "blue",
      failure_color = "red"
    )
  }
}

#' Create a shiny quiz widget
#'
#' @param id the id of the quiz
#' @param qu a list that contains the quiz fields as would have
#'        been parsed by read.yaml from package YamlObjects
#' @param yaml alternatively to qu, is yaml a string that specifies the quiz
#' @param quiz.handler a function that will be called if the quiz is checked.
#'        The boolean argument solved is TRUE if the quiz was solved
#'        and otherwise FALSE
shinyQuiz = function(id=paste0("quiz_",sample.int(10e10,1)),qu=NULL, yaml,  quiz.handler=NULL, add.handler=TRUE, single.check.btn=TRUE, defaults=quizDefaults(lang=lang), lang="en") {
  restore.point("shinyQuiz")

  if (is.null(qu)) {
    qu = read.yaml(text=yaml)
  }

  if (is.null(qu[["id"]])) {
    qu$id = id
  }
  if (is.null(qu$parts)) {
    qu$parts = list(qu)
  }


  qu$single.check.btn = single.check.btn
  if (qu$single.check.btn) {
     qu$checkBtnId = paste0(qu$id,"__checkBtn")
  }

  qu$parts = lapply(seq_along(qu$parts), function(ind) init.quiz.part(qu$parts[[ind]],ind,qu))
  np = length(qu$parts)
  qu$state = as.environment(list(part.solved=rep(FALSE,np), solved=FALSE))

  qu$ui = quiz.ui(qu)

  if (add.handler)
    add.quiz.handlers(qu, quiz.handler)
  qu
}

init.quiz.part = function(part=qu$parts[[part.ind]], part.ind=1, qu, has.check.btn=!qu$single.check.btn, defaults=quizDefaults()) {
  restore.point("init.quiz.part")

  part = copy.into.missing.fields(dest=part, source=defaults)

  if (!is.null(part[["sc"]])) {
    part$choices = part$sc
    part$type = "sc"
  } else if (!is.null(part[["mc"]])) {
    part$choices = part$mc
    part$type = "mc"
  }


  if (!is.null(part$choices)) {
    correct.choices = which(str.ends.with(part$choices,"*"))
    if (is.null(part$multiple)) {
      part$multiple = length(correct.choices) != 1
    }
    part$correct.choices = correct.choices
    part$choices[correct.choices] = str.remove.ends(part$choices[correct.choices],right=1)
    part$answer = unlist(part$choices[correct.choices])
    names(part$choices) =NULL
    if (part$multiple) {
      part$type = "mc"
    } else {
      part$type = "sc"
    }
  } else if (!is.null(part$answer)) {
    if (is.numeric(part$answer)) {
      part$type = "numeric"
      if (is.null(part$roundto)) part$roundto=0
    } else {
      part$type = "text"
    }
  } else {
    stop(paste0("The quiz with question ", part$question, " has neither defined the field 'answer' nor the field 'choices'."))
  }


  txt = colored.html(part$success, part$success_color)
  part$success =  markdownToHTML(text=txt,encoding = "UTF-8", fragment.only=TRUE)

  txt = colored.html(part$failure, part$failure_color)
  part$failure =  markdownToHTML(text=txt,encoding = "UTF-8", fragment.only=TRUE)

  part$id = paste0(qu$id,"__part", part.ind)
  part$answerId = paste0(part$id,"__answer")
  if (has.check.btn) {
    part$checkBtnId = paste0(part$id,"__checkBtn")
  } else {
    part$checkBtnId = NULL
  }
  part$resultId = paste0(part$id,"__resultUI")
  part$ui = quiz.part.ui(part)
  part$solved = FALSE

  part
}

quiz.ui = function(qu, solution=FALSE) {
  restore.point("quiz.ui")
  pli = lapply(seq_along(qu$parts), function(i) {
    part = qu$parts[[i]]
    if (i < length(qu$parts)) {
      hr = hr()
    } else {
      hr = NULL
    }

    if (solution) {
      if (is.null(part$sol.ui)) {
        part$sol.ui = quiz.part.ui(part, solution=TRUE)
      }
      return(list(part$sol.ui,hr))
    } else {
      return(list(part$ui,hr))
    }
  })
  if (!is.null(qu$checkBtnId)) {
    pli = c(pli, list(actionButton(qu$checkBtnId,label = "check")))
  }

  pli
}

quiz.part.ui = function(part, solution=FALSE, add.button=!is.null(part$checkBtnId)) {
  head = list(
    HTML(paste0("<p>",part$question,"</p>"))
  )
  if (solution) {
    if (part$type=="numeric") {
      answer = numericInput(part$answerId, label = "",value = part$answer)
    } else if (part$type =="text") {
      answer = textInput(part$answerId, label = "",value = part$answer)
    } else if (part$type=="mc") {
      answer = checkboxGroupInput(part$answerId, "",part$choices,selected = part$answer)
    } else if (part$type=="sc") {
      answer = radioButtons(part$answerId, "",part$choices, selected=part$answer)
    }
  } else {
    if (part$type=="numeric") {
      answer = numericInput(part$answerId, label = "",value = NULL)
    } else if (part$type =="text") {
      answer = textInput(part$answerId, label = "",value = "")
    } else if (part$type=="mc") {
      answer = checkboxGroupInput(part$answerId, "",part$choices)
    } else if (part$type=="sc") {
      answer = radioButtons(part$answerId, "",part$choices, selected=NA)
    }
  }

  if (add.button) {
    button = actionButton(part$checkBtnId,label = "check")
  } else {
    button = NULL
  }
  list(head,answer,button, uiOutput(part$resultId))
}



add.quiz.handlers = function(qu, quiz.handler=NULL){
  restore.point("add.quiz.handlers")
  app = getApp()
  if (is.null(app)) {
    cat("\nCannot add quiz handlers since no shinyEvents app object is set.")
    return()
  }

  if (!qu$single.check.btn) {
    for (part.ind in seq_along(qu$parts)) {
      part = qu$parts[[part.ind]]
      buttonHandler(part$checkBtnId,fun = click.check.quiz, part.ind=part.ind, qu=qu, quiz.handler=quiz.handler)
    }
  } else {
    buttonHandler(qu$checkBtnId,fun = click.check.quiz, part.ind=0, qu=qu, quiz.handler=quiz.handler)
  }
}

click.check.quiz = function(app=getApp(), part.ind, qu, quiz.handler=NULL, ...) {
  restore.point("click.check.quiz")

  # check all parts
  if (part.ind == 0) {
    for (part.ind in seq_along(qu$parts))
      click.check.quiz(app=app, part.ind=part.ind,qu=qu, quiz.handler=NULL)

    if (!is.null(quiz.handler)) {
      quiz.handler(app=app, qu=qu, part.ind=0, part.correct=NA, solved=qu$state$solved)
    }
    return(qu$state$solved)
  }

  part = qu$parts[[part.ind]]
  answer = getInputValue(part$answerId)


  if (part$type =="numeric") {
    answer = as.numeric(answer)
    correct = is.true(abs(answer-part$answer)<part$roundto)
  } else {
    correct = setequal(answer,part$answer)
  }
  if (correct) {
    cat("Correct!")
    setUI(part$resultId,HTML(part$success))
  } else {
    cat("Wrong")
    setUI(part$resultId,HTML(part$failure))
  }
  qu$state$part.solved[part.ind] = correct
  qu$state$solved = all(qu$state$part.solved)

  if (!is.null(quiz.handler)) {
    quiz.handler(app=app, qu=qu, part.ind=part.ind, part.correct=correct, solved=qu$state$solved)
  }

}
