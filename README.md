# TrumpBot2016

This is a project to give me some practice with implementing a chatbot
and an AIML 2.0 interpreter.

The 'brains' of TrumpBot are based on the Rosie chatbot base from Pandorabots: https://github.com/pandorabots/rosie

TrumpBot is currently hosted [here](http://shielded-fortress-9359.herokuapp.com/).

# Next up TODOs

* Look into expanding upon trumpbot.rake to accelerate training (and maybe scrap the training controller).
* Implement support for `<topic>`
* Add unit tests for Graphmaster and BotBrain.
* Is the whole BotBrain response -> ChatResponse -> QueryBot response flow necessary? Perhaps we should simplify.
* Try to treat TemplateContentNode implementations as immutables (limit setting of ivars to initializer)
* Look into organizing AIML files in a way that makes more logical and/or intuitive sense for TrumpBot.
