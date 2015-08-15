# TrumpBot2016

This is a project to give me some practice with implementing a chatbot
and an AIML 2.0 interpreter.

# Next up TODOs

* Build a training interface to accelerate the building of TrumpBot's brain (maybe use Pandorabots trainer as a guide)
    * Populate THAT field correctly
    * Populate TOPIC field correctly
    * Implement basic Say Instead
    * Add more items to this list once above are completed.
* Chat interface improvements
    * Replace placeholder timestamps with real values
    * Replace form submissions and page reloads with AJAX calls and DOM updates.	
* Implement support for `<topic>`
* Make PatternMatcher and Chat specs independent of production Graphmaster instance.
* Move away from quick and dirty stuffing of JSON object into chat_sessions table.
* Is the whole BotBrain response -> ChatResponse -> QueryBot response flow necessary? Perhaps we should simplify.


