# GONOGO analyzer

## Usage
You will mainly need only two functions from this package:

`load_exeperiment`: loads csv data as exported by pebl
`participant_performance`: creates a summary

## Task description

The task displays P or R letter on the screen in 4 different positions defined by the X and Y coordinates. In some trials particiapnts are required to react to P and in some to R. The correct 

## Analysis output

participant performance outputs a collective analysis for each stimulus (go/nogo, P/R) separately. The table has many columns which follow this naming structure

`[type of data]_[go nogo task]_[trials with errors or correct trials]_[target go stimulus]`

more specifically:

`[mean_rt/median_rt/sd_rt/accuracy]_[go/nogo]_[correct/error]_[P/R]`


- mean/median/sd RT = reaction time information in ms. If NA, then no trials of this nature were recorded (e.g. no participant made no mistakes in nogo trials)
- accuracy = ratio of correct answers (0-4)
- go/nogo = type of task. If target stimulus is R, then R is a go task and P is nogo task.
- correct/error = participant answered correctly or made a mistake
- P/R = target go stimulus

For example. if the column is `mean_rt_nogo_error_R` then it contains a mean erroneous reaction time in nogo R trials (participants should only react to R, but P is shown and participants reacts anyway). If this value is NA, then we should expect the accuracy_nogo_correct_R to be 1, as no mistakes were made.
