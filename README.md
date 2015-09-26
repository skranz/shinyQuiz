# Creating shiny widgets for quizes

Works for shiny events apps (see shinyEvents package). A quiz is currently described in yaml format and then parsed into R.




```r
library(shinyQuiz)
# A simple multiple choice quiz
yaml = '
question: What is 20*20?
mc:
  - 100
  - 200
  - 400*
  - 500
'

# A shiny app with events handling from shinyEvents
app = eventsApp()

qu = shinyQuiz(id="myquiz", yaml=yaml, quiz.handler=function(qu,solved,...) {
  cat("\nQuiz solved = ", solved)
})
app$ui = qu$ui
runEventsApp(app, launch.browser=rstudio::viewer)
```

The output looks as follows:
<!--html_preserve--><p>
<p>What is 20*20?</p>
<div id="myquiz__part1__answer" class="form-group shiny-input-radiogroup shiny-input-container">
<label class="control-label" for="myquiz__part1__answer"></label>
<div class="shiny-options-group">
<div class="radio">
<label>
<input type="radio" name="myquiz__part1__answer" value="100"/>
<span>100</span>
</label>
</div>
<div class="radio">
<label>
<input type="radio" name="myquiz__part1__answer" value="200"/>
<span>200</span>
</label>
</div>
<div class="radio">
<label>
<input type="radio" name="myquiz__part1__answer" value="400"/>
<span>400</span>
</label>
</div>
<div class="radio">
<label>
<input type="radio" name="myquiz__part1__answer" value="500"/>
<span>500</span>
</label>
</div>
</div>
</div>
<div id="myquiz__part1__resultUI" class="shiny-html-output"></div>
<button id="myquiz__checkBtn" type="button" class="btn btn-default action-button">check</button>
</p><!--/html_preserve-->


### Showing a quiz solution as HTML


```r
ui = quiz.ui(qu, solution=TRUE)
p(ui)
```

<!--html_preserve--><p>
<p>What is 20*20?</p>
<div id="myquiz__part1__answer" class="form-group shiny-input-radiogroup shiny-input-container">
<label class="control-label" for="myquiz__part1__answer"></label>
<div class="shiny-options-group">
<div class="radio">
<label>
<input type="radio" name="myquiz__part1__answer" value="100"/>
<span>100</span>
</label>
</div>
<div class="radio">
<label>
<input type="radio" name="myquiz__part1__answer" value="200"/>
<span>200</span>
</label>
</div>
<div class="radio">
<label>
<input type="radio" name="myquiz__part1__answer" value="400" checked="checked"/>
<span>400</span>
</label>
</div>
<div class="radio">
<label>
<input type="radio" name="myquiz__part1__answer" value="500"/>
<span>500</span>
</label>
</div>
</div>
</div>
<div id="myquiz__part1__resultUI" class="shiny-html-output"></div>
<button id="myquiz__checkBtn" type="button" class="btn btn-default action-button">check</button>
</p><!--/html_preserve-->

