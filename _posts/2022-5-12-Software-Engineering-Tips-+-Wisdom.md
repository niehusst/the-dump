---
layout: post
title:  "Software Engineering Tips + Wisdom"
subtitle: "Live doc!"
background: "/assets/imgs/braindump2.png"
---

Over my time reading about and being a Software Engineer, I've gathered a small collection of
tips and learnings that I thought would be nice to record in writing for future me, or others.
This list is a living document, so I may come back to update it from time to time as I learn
more. Also, each bullet in this list is in no particular order and is purposely concise;
each bullet could (and may in the future) be its own blog post, but this list is supposed to
stay as snappy as possible.

## The list:

* Without actionable insights (aka metrics), no timely strategic decisions can be made
* Don't optimize too early; YAGNI
* Move fast when you need (for business survival reasons, generally), address tech debt when you can
* [CI/CD lets you move fast with confidence](https://niehusstaab.com/the-dump/2022/05/10/CICD-The-best-thing-you-didnt-learn-in-school.html)
* Good (or any) code architecture may not be necessary early on for small teams, but will become increasingly important as the team grows
* Consider ease of deployment when designing a code architecture
* The flexibility of your code is more important than the functionality of your code (flexible code with bugs in it can be changed)
* Code duplication is ok if the use cases of the duplicated code may diverge; only unify duplicated code if it would always change at the same time anyway
* Code architecture should try to be agnostic; put off making decisions until you know what your needs are (this also incurs greater code flexibility)

Edit 9/14/22

* Monitoring lets you know about code stability after release
* A little operational excellence can go long way for team agility
* Follow semantic versioning (at least mostly)! It will help you/clients avoid dependency hell
* Version pinning (for deps and/or network end-points) helps prevent breaking changes (including to previously released versions, in the case of end-point version pinning)
* Use the [Humble Object](https://devlead.io/DevTips/HumbleObject) pattern to improve testability + flexibility
* Tests that are strongly coupled to implementation (i.e. testing UI string values) are rigid, fragile and basically worthless; they can only tell you that your code has changed
* Design your systems for testability
* As much as possible, don't depend on volatile code
* When building something: 1) Make it work. 2) Make it right (refactor for flex/readability). 3) Make it fast (only as much as needed though).
* [Manage up](https://www.tinypulse.com/blog/what-does-it-mean-to-manage-up), don't manage down
* If you wish there was documentation for something on your team, make it yourself while you figure out the information you needed
* Communication! Yes, this is just as important for devs as it is for anyone else.
* Don't say "yes" to everything (you have a limit, you will reach it), say "yes, but...". Explain the trade-off you will have to make if you accept extra tasks
* Keep on the same page after meetings by sending an email with the agreed action items (doubles as receipts against managers re-writing history)
* Code is a liability; opt for [Taco Bell programming!](http://widgetsandshit.com/teddziuba/2010/10/taco-bell-programming.html)

Edit 4/12/23

* The art of software engineering isn't the coding, it is asking enough questions to know what the actual problem to be solved is.

Edit 12/6/24

* Don't silo your teams; trusting and empowering everyone to do anything in the system will make everyone faster and happier. Cooperation > Parallelization. [Egoless Engineering](https://egoless.engineering)

Edit 12/30/24

* Be friendly. Software development is a team sport; if no one wants to work with you, it doesn't matter how big your brain is.
* Human connections (either a personal network or via recruiters) are a much more efficient way of landing a job than using online application portals (at least today). With increasing amounts of AI generated applications, even qualified applicants can be buried or filtered out.

