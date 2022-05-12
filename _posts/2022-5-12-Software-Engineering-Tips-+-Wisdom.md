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
* [CI/CD lets you move fast with confidence]({% post_url 2022-5-10-CICD:-The-best-thing-you-didnt-learn-in-school %})
* Good (or any) code architecture may not be necessary early on for small teams, but will become increasingly important as the team grows
* Consider ease of deployment when designing a code architecture
* The flexibility of your code is more important than the functionality of your code (flexible code with bugs in it can be changed)
* Code duplication is ok if the use cases of the duplicated code may diverge; only unify duplicated code if it would always change at the same time anyway
* Code architecture should try to be agnostic; put off making decisions until you know what your needs are (this also incurs greater code flexibility)
