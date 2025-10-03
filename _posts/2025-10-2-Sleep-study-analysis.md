---
layout: post
title:  "Sleep study analysis"
background: "/assets/imgs/bikedump.jpg"
---

# I've been having trouble sleeping enough

Mostly I've been waking up sometime in the night and then finding it difficult to go back to sleep.
I was interested in getting a sleep study done to see what that could tell me, but after some
cursory research online, I found that a sleep studies aren't cheap! It seems they typically require a specialist who
observes you sleeping at an appointment, or expensive equipment, like a breathing machine.

This was a lot more than I had in mind. So, being the miser I am, I decided to conduct my own "sleep study", free of charge.

## Earning my degree in somnology

I knew I would need data, so I opted to gather it by recording some simple info in a Google Form when I woke up every day.
The form had fields for the following:

- the date
- where I slept
- when I got into bed
- when I fell asleep
- anything that prevented me from falling directly to sleep after getting into bed
- when I (first) woke up
- why I woke up
- anything that kept me awake, if I was trying to go back to sleep
- when I went back to sleep (if applicable)
- when I woke up for the day for good

I recorded entries for ~6 months, finishing in July of this year. Then I exported it from google as a CSV
and got to work hacking on it with the shambly remains of the stats + data science skills I learned in college
7ish years ago. (My somnology advisor, ChatGePpeTto, put in a lot of work for me in the graph creation department.)

## Analysis

The first thing I wanted to know: how much sleep am I generally getting? Are there any obvious patterns?

![Sleep time scatter plot](/assets/posts/sleep_study/sleep-time-scatter_5.png "Sleep time scatter plot")
*Pardon the undiscernible date labels*

My average sleep time is 7.5 hours. Most nights are in the range of 7-8 hours, which was much better than I feared.
There don't appear to be any patterns of continuous days of too little/too much sleep in a row, and the sleeping
location does not seem to have had a large effect on average amount of sleep.
There are certainly a few outliers, but nothing that indicates a major trend extending beyond a single night.

Next I wanted to know if there's a correlation between the time I went to sleep, and the amount of sleep I got.

![Sleep time by hour](/assets/posts/sleep_study/sleep-time-by-hour-whisker_6.png "Sleep time by hour")

Very roughly, you can see the median amount of sleep decreases the later I fell asleep.
If a line were drawn through the medians from 7pm to 7am, it would have a generally negative slope.

This is not super surprising, since I have an alarm at 7am most days (the cat's breakfast waits for no man),
but it is good to see that common sense holds true in this regard. I do wonder if the slight negative slope
would be more pronounced in the data if I removed records where I was initially awakened by my morning alarm,
and then decided to go back to sleep again. Nonetheless, it is an important learning for me
that going to bed earlier generally enables more sleep.

Looking at some other numbers that don't graph quite as nicely: 

I slept between 7 and 8 hours **45.7%** of nights (remainder being **54.3%** of nights are outside that average range).
Of those non-average nights, I somehow managed to have an equal number of nights sleeping under 7 hours, as over 8 hours
(each **27.2%** of the total). 

When trying to fall asleep, it generally took **45 minutes** to go to sleep after getting into bed,
and **1 hour** to get back to sleep after waking up in the middle of the night.

With this information, I was curious what was preventing me from getting to sleep in these cases. Knowing that I generally
recorded 15 minutes as the time to fall asleep if I did nothing after getting into bed, I filtered the data for only
entries with a difference between bed time and sleep time longer than 30 minutes.

![Kept from sleep bar chart](/assets/posts/sleep_study/kept-from-sleep_1.png "Kept from sleep bar chart")

While reading is the #1 thing keeping me from getting to sleep after getting into bed, it was expected
and is acceptable to me, as most cases (as we'll see in the box and whisker plot to come) are shorter
periods that I'm reading before bed to get sleepy.

So I'm primarily concerned with how much time each of these top reasons are keeping me awake. Luckily,
a box and whisker chart can tell me exactly this kind of information if I graph the time delta ("latency")
between when I got into bed and when I fell asleep, by reasons that kept me from falling asleep.

![Latency getting to sleep](/assets/posts/sleep_study/get-to-sleep-latency_3.png "Latency getting to sleep")

As expected, even though 'reading' is the most frequent reason keeping me awake before sleep, it's only for 1 hour by its median,
and even its most distant outlier is 3 hours.

I can see in this graph that there are a few big outliers that are caused by single occurrences.
To clarify a quirk about this data, when I made an entry in the Google Form, I could include multiple reasons for keeping me
awake. Which means one night's entry can be represented by multiple reasons
(e.g. 'anime' and 'not sleepy' have overlapping outlier data points from the night I stayed up watching anime for 7 hours).

The more generic reasons show the greatest spread of data points (possibly due to multiple factors combining to keep me awake longer?),
with 'difficulty breathing' and 'wanting to do something' being the biggest offenders.
'restless', 'hungry', 'not sleepy' and 'racing thoughts' follow, but have lower spreads, most data being
around the 1-2 hour mark.

My best guess is that not being able to get my mind into a sleepy state is a major thing keeping me awake.

Next I wanted to see what's waking me up most often.

![Waking reasons](/assets/posts/sleep_study/waking-reasons_7.png "Waking reasons")

Unsurprisingly, my 7am alarm is a big leader. So let's look at this chart again, but filtered for initial wake-up times before 6am.

![Waking reasons before 6am](/assets/posts/sleep_study/waking-reasons-early_8.png "Waking reasons before 6am")

*Pay no mind, the decimal y axis ticks, when the chart shows only integer counts*

The timezone conversions to get this graph were a little flimsy, so I'm not sure about the quality of data in this graph,
but it's an attempt. Looks like I have a contradictory combination of dehydration and needing to pee a lot.

Now to look at graphs of what keeps me from sleeping after waking up in the night, to see if there are similar
causes to what keeps me from getting to sleep in the first place.

![Kept me awake after initial wake-up](/assets/posts/sleep_study/kept-awake-after-wakeup_2.png "Kept awake after wake-up")

Being physically and mentally restless are the most frequent issues keeping me awake, followed by hoping (and failing) to go back to sleep
without eating a snack.

Now again, to follow up with a box and whisker chart to see which reasons are actually keeping me awake longest.

![Latency returning to sleep](/assets/posts/sleep_study/return-to-sleep-latency_4.png "Latency returning to sleep")

Those top most frequent reasons show similar-ish spreads, with medians in the 2-3 hour range.
Being hungry should have a simple solution, yet it still holds a median latency of around 3 hours.
In my expert opinion, this may be an indicator that "hungry" is a gateway to other reasons that 
will keep me awake longer. I suspect this to also be the reason behind "difficulty breathing"
having such a high median latency. (As with the previous latency graph data, there is
overlap of 1 event sharing its sleep latency weight across multiple reasons.)

Curiously, "racing thoughts" has a lower median latency (~1 hour) than "restless" (~2 hours). Quickly resolving physical restlessness
appears to be more difficult, perhaps because it is more likely to get me out of bed, and therefore further from sleeping.

But the highest median latency, at around 5 hours, is "wanting to do something". Typically this is something I'm excited or anxious to do the next
day, but I just can't unfocus from it once waking up. From experience, this is not a reason that can be resolved by just doing it
and getting it out of the way; the things I usually want to do are just too large scale (like working on a project, or playing a video game).

Noticeably, whether going to sleep initially, or after waking up in the middle of the night,
these top 2 reasons by median ("difficulty breathing" and "wanting to do something") are indeed the same. 

## Conclusions

The main learnings I've gotten from this self-administered sleep study are to go to sleep earlier, 
give into what my body wants if I wake up, and then get back in bed and really try to go back to sleep.

Unless there's something I really want to do, in which case I just have to beat myself over the head with a rolling pin
until I return to unconsciousness. That's a prescription from a self-certified somnologist, so you know you can trust it.

And recently, I feel like I've been getting more sleep more frequently (I think? I stopped gathering data in July).
So I guess it's working???
