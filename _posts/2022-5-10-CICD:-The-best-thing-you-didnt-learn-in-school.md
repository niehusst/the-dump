---
layout: post
title:  "CI/CD: The best thing you didn't learn in school"
background: "/assets/imgs/braindump2.png"
---

One of my favorite things that I've gotten a chance to learn in my time working at Honey/PayPal is
GitHub Actions for Continuous Integration and Continuous Deployment (CI/CD). Automating arduous
or recurring tasks is one of my favorite things to do at work now, since it gives me and my coworkers
time back that we can now use for cleaning up tech debt or more feature work.

In school, there is often little to no need for CI/CD because most works of software produced needs neither to be integrated into,
nor deployed, continuously. The automated test suites ubiquitous on HackerRank, LeetCode, and the like are
often as close as many students get to CI/CD before being immersed in real software engineering.
While automated testing is a core pillar of CI/CD, it is far from all CI/CD has
to offer. I find it almost criminal that such an important part of commercial software development was completely
omitted from my curriculum (perhaps this was due to my school being a liberal arts college rather than a technical college).

So why do I think it's so important? Aside from the aforementioned time savings, CI/CD, at its heart,
is about giving developers the confidence and ability to move fast. I shouldn't have to tell you
the value of being able to rapidly adapt to new product requirements, beat competitors to market,
quickly release critical bug-fixes or security patches, or swiftly iterate. CI/CD does all this in an automated fashion
by quickly exercising each new code change against rigorous checks to validate its functionality,
and (ideally) making deployment an unceremonious single button click that can be performed by anyone at any time.

While those are the main pillars of CI/CD, they are very broad and can (and should) be stretched to
fit a variety of, perhaps surprising, other things. A short list of some of my favorite uses on the
Honey iOS team: 
* linting and code format enforcement
* [conventional commit](https://www.conventionalcommits.org/en/v1.0.0-beta.2/) enforcement for automated semantic version updates
* token rotation
* releasing debug builds to QA for each PR
* automated app translation requests and imports

There's so much amazing automation that can be done in the world of CI/CD to improve developer productivity,
which is why I love it so much. I prefer GitHub Actions because of its tight integration with GitHub,
good docs, and public API, but CircleCI and Jenkins will get the job done too.
