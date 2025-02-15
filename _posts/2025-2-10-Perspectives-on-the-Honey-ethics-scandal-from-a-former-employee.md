---
layout: post
title:  "Perspectives on the Honey ethics scandal from a former employee"
background: "/assets/imgs/bikedump2.jpg"
---

On December 21, 2024, YouTuber Megalag posted a video called "Exposing the Honey Influencer Scam" accusing the company Honey (or PayPal Honey, as PayPal would like it to be called since acquiring it in 2020)
of lying to users and stealing from its marketing partners. Apparently, some of these details were already well known amongst YouTubers
(the main marketing partners affected), but it wasn't until Megalag's video that the issues were drawn to the attention of the general public, myself included.

I worked at Honey from 2020 to 2022 as a mobile app engineer.
And I care a lot about professional ethics, so I was shocked by the allegations, and honestly a little disappointed in myself for not having done enough research to figure out it was unethical on my own before deciding whether to work there.
So today I'd like to review the allegations against Honey, share some commentary and internal perspectives on them, and then reflect a little on what I could have done differently.


## What are the allegations against Honey?

#### 1. Stealing affiliate revenue from influencers

Whenever a user interacts with the Honey browser extension (this could be finding and applying a coupon, or simply clicking a button to close the extension
popup when there are no deals available), Honey writes its affiliate code to a designated cookie, possibly overwriting any existing value with its own. In effect, 
this hi-jacks the affiliate commission from anyone that may have linked a Honey user to a ecommerce marketplace with their own affiliate URL. 

This was particularly damaging to 
YouTubers, since many of their sponsors provide them with affiliate URLs to pay them via commissions, or measure the success of a sponsorship. And since Honey sponsored a lot of 
YouTubers for marketing in their early years, it felt parasitic for Honey to have YouTubers market a tool that will secretly hurt their own bottom-line.

#### 2. Lying to shoppers about finding the best deal

Honey's consumer-facing mission statement is that they'll find you the best deals on the internet, claiming to have scoured it for coupons so that you don't
have to. It seems that this isn't always true; Honey actually lets its partners control which coupons are available. 

Honey does this because it makes money through partnering with businesses and then acting as an affiliate marketing
agent. Honey drives more sales to the partner business, and in return, they share some percentage commission from the sales Honey converts. As an extra perk for their partners, Honey also offers them control over the coupons it will show to users. These
two value propositions are in conflict with one another; you can't always present the best deal to the users if you're also giving the marketplace control over
which deals Honey will show.

#### 3. Damage to businesses

This is only alluded to at the end of the Megalag video, and is teased as part of a part 2 video (which has yet to release at the time of writing this),
but it seems implied that some businesses are being hurt by Honey's users overusing high-discount coupons. 

Honey runs on most marketplaces across the internet, and
certainly not all of them have a partnership deal with Honey (meaning, pay Honey an affiliate commission in exchange for promotion and "access" to its millions of users),
after all, Honey can't provide as much value to users if it only shows them coupons on a subset of marketplaces. And one of the ways Honey collects coupon codes (I know this
since I was curious about it while I worked for Honey) is that every time a Honey browser extension user applies a coupon, if it was successfully applied to the user's cart,
Honey will add it to its database. 

So, the Megalag video seemed to be saying that coupons that were only intended for 1 user, or a select group of users,
may be escaping into the wild through the Honey browser extension, and then getting used more widely than the businesses intended, causing lost revenue from a decrease in
full-price purchases. The businesses most likely to be hurt by this kind of coupon over-use would most likely be the smaller businesses that are less likely to have the tools or
forethought to limit coupon usage properly. And if these businesses were to reach out to Honey about they issue, Honey (being a business looking to make money) would
have likely responded with a sales pitch for their partnerships product, which allows the business to control which coupons Honey surfaces on their site. This sounds a lot
like a protection racket, since Honey would have created the problem they would be charging to solve.

## Internal perspectives on the allegations

The cause of Honey's affiliate commission hi-jacking is not as sinister as it may seem (though the effect is no less negative). Honey implements last click attribution, which is where the last clicked ad (or affiliate, in this case) takes all the credit and commission for a conversion. This is very
common practice in affiliate business since it is very easy to implement; if you get clicked, write to the affiliate cookie to take the credit. What sets Honey apart 
from other affiliate competition is that Honey is a browser extension configured to run on most online marketplaces, so it will always be better positioned than
influencers' affiliate links to get that last click before you check out, and thus take the commission.

Something that felt really scummy to me when I watched the Megalag video, was his finding that Honey will take the last click attribution even if Honey doesn't show you
any coupons or cashback opportunities; if you interact with the Honey extension at all, it will write to the affiliate cookie. Particularly when imagining that
there may already be someone else's affiliate code in the cookie, it looks like Honey is stealing the commission from them without doing any work. But from Honey's perspective,
they have provided value to the customer by giving them the peace of mind that there aren't any better deals to be had and that this is as cheap as it
gets if they want to buy the product (although this line of thought is completely undermined by the allegation that Honey isn't necessarily showing their users
the best deals). What this really boils down to is Honey trying to provide more conversions to their business partner, and if they succeed in convincing a user to checkout,
Honey thinks it deserves the commission. 

This then begs the nebulous question: at which point did the user actually decide to buy something? When they clicked an influencer's affiliate link to go to the marketplace,
or after reaching the checkout page and getting a last push from Honey, which may have provided a coupon, cashback, or a (potentially false) confidence that they have the best deal possible? There's no
way to know the answer to this question without being inside the user's mind (and for that reason, I hope this question remains unanswerable forever), so as a business looking to make a profit,
Honey is obviously going to decide in its own favor whenever it can.

It was clear from the evidence in Megalag's video that Honey currently has no interest in resolving the issues with influencer affiliate attribution being
overwritten (likely because that would mean Honey would have to give up some fraction of the affiliate earnings it currently makes). However, I heard from one of my 
former co-workers that there was, at one point, an internal list of URLs not to overwrite affiliate cookies for, but that it became unclear who controlled the list,
and as a result, it stopped getting updated. Without a deeper knowledge of Honey corporate history than I have, I can't say whether this was an employee lead initiative, 
or if leadership priorities changed at some point. But it is clear that there were people within Honey that noticed this at some point, and cared.

There isn't any technical reasoning behind the other two charges of lying and racketeering, so I'll leave my thoughts on them for the conclusion.


## My conclusions

Honey used to seem to me like a flash of selfless sharing in the grand capitalist money-making machine, but thanks to Megalag's efforts, it is now clear that Honey was not 
impervious to corporate greed just because it was founded on the idea of saving everyone money. I think this also illustrates the importance of doing your 
research and practicing professional ethics. It's critical to understand the exact details of how a company makes money for one to be able to reason about its 
motivations, and to therefore avoid ethical pitfalls. If more people are able to collectively push their businesses to value what's right over profits, then we all win (as
people living in this world, not as business owners trying to get rich).

When I first contemplated working for Honey, I was suspicious of their "free money", and many of my friends suspected it sold user data to make its money. So when I
interviewed and learned about Honey's monetization plan, I made the logical error that if it was not unethical to make money from affiliate marketing (which I
did not understand the technicals of at the time) and its mission was to save people money was ethical, then the whole company is therefore ethical.
If I had known more technical details about how affiliate commissions were awarded, or worked on the extension team instead of the mobile team, or more carefully researched why Honey's
monetization plan worked so well, or contemplated how the product would affect entities not part of the intended user groups, then I might have started to discover some
of the unethical effects Honey had. These are a lot of "might haves" and "could haves" if I'd just done a whole crap ton of work outside my expected work duties and
expertise. Clearly, practicing professional ethics takes a lot of effort and attention. It's a lesson to me to think more about business edge-cases and non-standard users. But we also don't
have to carry the burden of doing ethical research on all aspects of our work alone; we can start by seeking to better understand the business bit by bit, looking for and drawing attention to things in our own wheelhouses that seem suspicious, and supporting our coworkers when they
question company practices.

In my opinion, all the allegations against Honey are rather open-and-shut. The affiliate cookie overwriting can likely still be seen in your own browser today, and the 
evidence for lying to users and (likely accidentally) creating a discount protection racket is found almost completely within their own website FAQs 
(with the exception of the testimonials of the businesses alledging to be hurt). But, unless the legal case against it
determines otherwise, Honey is probably only guilty of being a business in a capitalist society. I don't like that Honey does all these things, and it did have the power,
and possibly forethought, to at the very least show more care. And if it had, Honey could have saved itself the scandal and been the force of good for the people it claims
to be. Or it might have been killed off by market forces; it's far from certain that Honey would have survived as a business
if it hadn't made the key decisions to use last click attribution, show coupons on non-partner sites, and offer partners control over which coupons are surfaced on their sites. It is certainly disheartening to think that more ethical versions of many of today's
biggest companies may have existed, and died specifically because they made more ethical decisions instead of always choosing profit.

Tangentially, an interesting question I thought of: was Honey's goal of finding their users the "best deals on the internet" ethically doomed from the beginning?
If Honey gives companies control over which coupons are shown, the users are not necessarily getting "the best deals" that Honey could offer.
If Honey doesn't give companies control over which coupons are shown, businesses risk damage to their bottom-line from high-discount-coupon over-use.
Either way, the users or the companies suffer. I always believe we should value individuals more than businesses, because businesses are more likely to have the resources
to deal with negative effects. But behind every business, there are people and livelihoods, and I don't think we should thoughtlessly discount that fact.

I don't think Honey was ever an EVIL company that intended to do EVIL things, but it is an informative example of how multiple business decisions optimized for profit can 
come together to cause such clear negative externalities. Whether your mission can be cast as moral or amoral itself, every decision holds weight, and must be weighed in context to
determine its ethicallity.

