# Creating shiny widgets for quizes

Works for shiny events apps (see shinyEvents package). A quiz is currently described in yaml format and then parsed into R.




```r
library(shinyQuiz)
# A simple multiple choice quiz
yaml = '
question: What is 20*20?
sc:
  - 100
  - 200
  - 400*
  - 500
success: Great, your answer is correct!
failure: Try again.
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

### A quiz with mutliple parts


```r
yaml = '
parts:
  - question: Which are square numbers?
    mc:
      - 12
      - 16*
      - 25*
      - 88
  - question: State pi up to 2 digits
    answer: 3.14
    roundto: 0.01
'

qu = shinyQuiz(id="myquiz", yaml=yaml, quiz.handler=function(qu,solved,...) {
  cat("\nQuiz solved = ", solved)
})
```


Cannot add quiz handlers since no shinyEvents app object is set.

```r
# Show output as HTML
p(qu$ui)
```

<!--html_preserve--><p>
<p>Which are square numbers?</p>
<div id="myquiz__part1__answer" class="form-group shiny-input-checkboxgroup shiny-input-container">
<label class="control-label" for="myquiz__part1__answer"></label>
<div class="shiny-options-group">
<div class="checkbox">
<label>
<input type="checkbox" name="myquiz__part1__answer" value="12"/>
<span>12</span>
</label>
</div>
<div class="checkbox">
<label>
<input type="checkbox" name="myquiz__part1__answer" value="16"/>
<span>16</span>
</label>
</div>
<div class="checkbox">
<label>
<input type="checkbox" name="myquiz__part1__answer" value="25"/>
<span>25</span>
</label>
</div>
<div class="checkbox">
<label>
<input type="checkbox" name="myquiz__part1__answer" value="88"/>
<span>88</span>
</label>
</div>
</div>
</div>
<div id="myquiz__part1__resultUI" class="shiny-html-output"></div>
<hr/>
<p>State pi up to 2 digits</p>
<div class="form-group shiny-input-container">
<label for="myquiz__part2__answer"></label>
<input id="myquiz__part2__answer" type="number" class="form-control"/>
</div>
<div id="myquiz__part2__resultUI" class="shiny-html-output"></div>
<button id="myquiz__checkBtn" type="button" class="btn btn-default action-button">check</button>
</p><!--/html_preserve-->

