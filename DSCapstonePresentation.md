DSCapstonePresentation
========================================================
author: Cassie Breen
date: November 30, 2017
autosize: true

PredictionWorks
========================================================

PredictionWorks is a web application that predicts what you are about to type next.

It helps you to save time by providing suggested words and phrases.  It also helps minimize spelling errors by providing words for you.

It can be used for formal writing (writing blogs, articles) as well as informal writing (social media, sms).


How the app works?
========================================================

PredictionWorks uses a simple n-gram language model to predict what you are most likely to type next.

This model predicts what you would type based on previous words you have entered. 

For example, you entered "Today I":
- It will firstly, find a match in the 3-grams model with "Today I", if there is a match provides the probable next word in order of descending probability.
- Otherwise, it will use the 2-grams model and use "I" to find a match and perform the same operation to find a probable match.

More on how it works
========================================================

The models are developed with data of various sources:
- news articles
- blogs 
- twitter 

That means you can input both formal and colloquial English and it can handle the predictions.


How to start using it?
========================================================

Visit [PredictionWorks](https://cb872.shinyapps.io/DSCapstone/) on shinyapps.io. It may take a moment for the app to initialize
