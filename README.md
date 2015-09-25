# TrumpBot2016

This is a project to give me some practice with implementing a chatbot
and an AIML 2.0 interpreter.

The 'brains' of TrumpBot are based on the Rosie chatbot base from Pandorabots: https://github.com/pandorabots/rosie

TrumpBot is currently hosted [here](http://shielded-fortress-9359.herokuapp.com/).

# Next up TODOs

* Look into organizing AIML files in a way that makes more logical and/or intuitive sense for TrumpBot.
* Look into expanding upon trumpbot.rake to accelerate training (and maybe scrap the training controller).
* Implement better mechanism for avoiding repeating tweets too often.
* Try to handle initialized acronyms and abbreviations shuch as U.S. and etc. better.
* Should TrumpBot be made more interactive by occasionally proactively peppering the user with questions?
* Implement support for `<topic>`
* Add unit tests for Graphmaster and BotBrain.
* Is the whole BotBrain response -> ChatResponse -> QueryBot response flow necessary? Perhaps we should simplify.
* Try to treat TemplateContentNode implementations as immutables (limit setting of ivars to initializer)
* Add selenium tests or request tests for chat UI.
* Look into better leveraging `<think>` and `<learn>` elements to make TrumpBot more engaging and 'intelligent'.
