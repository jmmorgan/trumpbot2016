# TrumpBot2016

This is a project to give me some practice with implementing a chatbot
and an AIML 2.0 interpreter.

# Next up TODOs

* Have submitted input message show up in Chat view immediately and put a thinking/typing placeholder for TrumpBot (responsiveness improvements)
* Build a training interface to accelerate the building of TrumpBot's brain (maybe use Pandorabots trainer as a guide)
    * Populate TOPIC field correctly
    * Implement basic Say Instead
    * Add more items to this list once above are completed.
* Implement support for `<topic>`
* Make ChatSession spec independent of production Graphmaster instance.
* Is the whole BotBrain response -> ChatResponse -> QueryBot response flow necessary? Perhaps we should simplify.
* Try to treat TemplateContentNode implementations as immutables (limit setting of ivars to initializer)

