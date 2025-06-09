---
layout: post
title:  "Project files: Website for playing Go"
subtitle: "Thoughts and challenges from building net-go"
background: "/assets/imgs/braindump.png"
---

After quite the extended period, I have finally (mostly) completed a project I started at the end of 2022! (Please, hold the applause until the end of the post.)

Back in December of 2022, a friend I was visiting taught me how to play the game Go.
We live in different states, so I was inspired to build a website where we could play Go
against each other. Of course, there are plenty of existing websites I could have used
to accomplish that goal (and have many more features). But this one would be mine, which
cannot be said of the competition.

Having settled on building a website with a market of 1 (perhaps 2 on a good day), I
was left with the exciting decision of what technologies I would use to build the
website. I must admit, trying out some new (to me) tech was another driving reason
for opting to build my own website. The frontend framework + language Elm had recently
been hyped-up to me by another friend, and I was interested in trying out Tailwind CSS
and Go (Golang from here on, for clarity) since they were popular on hackernews. I also
wanted to up my knowledge of Docker and devops fundamentals. Besides, 
building a website for Go using Go(lang) was just too funny of an idea for me to pass up.

If you'd like to check it out, you can see the code on [github](https://github.com/niehusst/net-go) 
and the deployed website at [playonlinego.xyz](https://playonlinego.xyz).
The rest of this post is about challenges I encountered and decisions I made along the way (mostly in chronological order).


## Initial client + server base

### Getting to know Elm

I started with a basic Elm app. For those who aren't familiar, Elm is strongly-typed
functional programming language that is closely tied to a frontend component framework
by the same name (filling the same role as React.js). They're mostly inseparable, so
fortunately that name shadowing is not terribly confusing... most of the time.

The official Elm framework documentation was a little sparse and left me unsure
how to build on the most basic starter app. So the [BeginningElm](https://elmprogramming.com/)
tutorial series was super helpful in giving me a deeper understanding of how to
build and work within the Elm framework. Having this free educational resource as a
base may have been critical in my enjoyment of working in Elm.

While both React and Elm are founded on the functional programming concept of pure functions,
(the rendered HTML should be result of applying a function to the current app state,
and there should be no side effects) Elm is much stricter at enforcing this than React. In my opinion, this makes Elm code much easier to reason about than React with all
its hooks.

The main structure of a (page or app) controller in Elm is defined by 3 functions (`view`, `update`, `init`) 
and the 2 data types they operate on (whatever data structure you choose for your `Model`, and a `Msg` type which operates somewhere between an enum and a union type).
The `init` function creates and returns the initial app state as a value of your `Model` type.
Then that state is passed to the `view` function to generate the DOM tree. Any DOM interactions
that trigger a `Msg` to be sent, are processed by `update`, which returns a new state
value based on the `Msg` and prior `Model`, which is in turn passed back to `view`.

There are, of course, some caveats and extra features you'll need for building more
complex, "real world" web apps. But the extensibility of that simple pattern is what
drives every Elm app. Since I would often go long stretches between working on this
project (part of the reason why it took so long), it was awesome to only need to
look at those 5 key definitions in a file to get back up-to-speed on how a page in 
my app worked and start working on it again. I imagine that's how Ruby on Rails developers 
feel when joining a new company with an existing rails app and that oh-so-familiar
project layout.

There are so many things I could say about how much of a joy it was to build in Elm,
but I think the 2 things that stood out most were the strong typing, and the friendly
compiler. If the code was incorrect, the compiler was able to give extremely helpful
error messages thanks to the strong typing. The strong typing made run-time errors
a thing of the past. I imagine it must still be possible to get one (Elm 
compiles to JavaScript after all, a language famous for its runtime errors) but I have 
no idea what witchcraft you'd have to apply to the compiler to get it to produce
erroneous code. 

Elm was not without its quirks though. I discovered the hard way that the Elm compiler
has a long-standing bug that prevents it from parsing negative numbers as switch case
match expressions. And if you REALLY want some global mutable state (session state in my
case), the Elm framework will fight you tooth and nail. (To solve that one, I had to
add the state to the Main controller's `Model`, and then intercept and spy on child pages' `Msg`s
to see if a session had been started or ended across any page on the site.)

But the biggest "quirk" of all is that Elm is basically dead. It appears that the author
has such a strangle-hold on the project that few (if any) significant features or
bug fixes have been added since 2019, when the latest version (0.19.1) of the compiler was released.
The author does not seem to be maintaining it particularly actively or allowing the community
to take over and contribute.
This was certainly disappointing to learn, but did not ultimately affect my ability to
use it for a hobby project.

Well, that's enough gushing about starting to use Elm. On to gushing about Golang!


### Golang decisions

Working with Golang was ok. It was pretty easy to learn and certainly lives up to the
tagline of "more ergonomic C". It gave me nothing to complain about, but I also
didn't have the same "wow" experience I had with Elm. Perhaps if I had gotten to use
more of the language features that really define Golang, I would have enjoyed it more.
But my boring CRUD server hardly needed to use channels or go-routines. I guess the web
framework abstracted away basically everything that they might have been necessary for.

I did some research about Golang web framework options, but at the time it seemed like
Gin was the only one that had much traction. Same for GORM, my choice of ORM for my
starting sqlite database. They were certainly safe and functional choices, but working
with a minimal web framework, like Gin, perhaps reminded me too much of my day job
working with express.js and flask. And some GORM tutorials I followed early on locked
me into a rather tedious dependency injection pattern which did allow me to write a
lot of unit tests at the cost of a lot of boilerplate code.

I was also a little disappointed with the packages available for web dev purposes.
Since Golang is known for being popular in devops work, I thought there would be
obvious choices for common problems, like auth. And yet, I ended up rolling my own
session validation and password salt + hashing implementation (against all advice ever). I can only
imagine I missed something, as it seems unlikely that there is such a glaringly large
hole in the Golang package ecosystem. At least it was educational and there will
never be sensitive data associated with the accounts (unless you willfully expose
it by putting it in your username).

All that was necessary to get the Gin server hooked up to serve my Elm app was to
serve the compiled JavaScript file and the base HTML file as static resources.
All the details of the eventual API were just simple CRUD endpoints.

## Game Logic

### The rules engine

Once I had a basic game board constructed from HTML and CSS, I needed to build
out the logic for validating moves and capturing surrounded pieces. I had initially
planned the app to be peer-to-peer, and to not store any game state or rules on
the server. I eventually changed course to a more standard CRUD model after realizing that most people might not
want to play an entire game of Go over the internet in 1 sitting. But not before I
implemented all the logic in Elm!

Go is a fairly simple game in concept, so there was a very manageable number of rules
to code. I also found it a fun little challenge to implement the logic
in Elm because it's a functional language, and I wasn't used to thinking recursively
for everything.

For game integrity, all the validation should also occur on the server, to make sure
a player doesn't just send a game state that would be unreachable from the prior one in a single move.
But I've had higher priorities just getting the website working and deployed, so this
is still a TODO. (sshhh don't tell anyone)

With all the rules implemented, I could play Go against myself, and all the rules
would be enforced by my rules engine each time I played a stone (aka piece) on the board. 
The multiplayer
functionality wasn't implemented yet at this point; all game state was only stored
in process memory, and which color I was playing as would swap on each move, allowing
me to play against myself during testing.


### The difficulty in scoring

While programming the rules of play was very straightforward, I ran into a brick wall
when I got to scoring. 

Incredibly quick rundown of how you score points in Go: you want to surround as much
space on the board as possible with your stones. Each empty space you surround is worth
1 point. You can also contest territory by
playing inside the space your opponent is trying to surround. You can "win" this
contest, and prevent your opponent from getting points for the territory by creating "life" (you
look it up. I don't want to explain it and it's not relevant to the rest of this blog post).
But if your contesting
stones get completely surrounded by the opponent (i.e. no empty space within them or
separating them from opponent stones on any side) then your contesting stones are
captured and removed from the board. Stones you capture count toward your score.

In the most complete case, where there is no longer any contested territory, scoring 
a game of Go is easy. You just count up the area of all open spaces and attribute the
points to the player that surrounded the area. But realistically, this never happens; playing
a game of Go (especially on a full-size board) can take hours, and people usually give up
contesting some territories as lost causes before their pieces actually get captured.
Being forced to play out all the moves necessary to shore up these forgone conclusions
would be incredibly boring and time-consuming.

The way scoring a game of Go on a physical board usually works is when the
2 players agree the game is over (assuming no one resigned, this is typically signaled
by both players passing their turn back-to-back), they decide between each other 
which stones have no chance at creating "life", and remove these "dead" stones from
the board until they reach a state where there is no longer any contested territory on
the board. From here, scoring proceeds quite simply as explained above.

The snag for me arose when I decided that I didn't want to add a phase to my web version
of the game where the players would have to manually identify and agree upon these dead stones; I felt like it should be completely automated. This belief of mine was further
supported by a GameBoy Advance game I played that was based on the Hikaru no-Go anime/manga,
which was able to score a game of Go without such a phase.
Yet I couldn't figure out how to identify these dead stones in an automated fashion;
after all, any arbitrary structure of stones on the board may live or die by the right
sequence of moves, for all the computer knows.

I looked high and low online for scoring algorithms, since I knew they had to exist
from the plethora of existing Go websites and games with automated scoring. I found
no handy wikipedia articles, or academic papers explaining how I could score a game
of Go (although I did learn about a different method of scoring, called area scoring,
that I decided against using in every case because it can occasionally differ in
result from the territory scoring method I was familiar with. And by this time I was
tilted and wanted to solve the problem, not skirt around it). Only after using some
advanced search tools on GitHub was I able to find an open source implementation of
automated removal of dead stones. I was disappointed (though not shocked, having
grasped the difficulty of the problem from my research) to find that this lone
implementation of Go scoring used a Monte Carlo simulation to play the board to a
complete state, enabling the standard scoring procedure.

This Monte Carlo simulation takes turns playing a random (legal) move for each player
until no legal moves are left on the board, therefore completing the game. It performs
this operation of random play some number of times (100 in my current implementation)
in order to build up a percentage of games for which each square is in which state 
(white stone on square, black stone on square, or square is empty).
Where the percent chance of a square being in one specific state is above 50% across all
iterations, I change the state of that square to match on the final game board. 
Probabilistically, dead stones should
always occupy squares that will be empty, or occupied by the opponent in the majority of simulations,
causing them to be removed, or replaced, on the board before scoring begins.

Implementing all of this in Elm (yes I was still designing under the assumption it
would be a peer-to-peer app at this time) was challenging because its strict adherence
to pure functions made it a pain to achieve the randomness I required for making 
random moves. The complexity of the implementation and the long, disheartening research
phase caused the scoring feature to take ~6 months to complete.

And after all that, scoring was slow and would freeze the browser, since browser
JavaScript is single-threaded! I had to introduce a web worker to run the scoring in
the background properly. But since Elm doesn't have native
support for the web worker browser APIs, this added another little hick-up. Plus, I 
didn't want to rewrite all my scoring logic into JavaScript and lose all the benefits
of working in Elm that I had been enjoying. 

Luckily, Elm has an escape hatch into 
JavaScript land, called ports, for just such an occasion. Basically, Elm ports allow
you to serialize Elm state to JSON and send it to JavaScript, then JavaScript can
send `Msg`s and JSON back to Elm for it to deserialize and handle. Elm also has the
ability to run a "headless" version of the framework (i.e. no `view` function for rendering HTML)
as a standalone JavaScript process. By using ports, headless Elm, and a little bit
of JavaScript to handle the web worker API, I was able to keep all my scoring logic
in Elm without blocking the main thread.

Even so, I noticed that if I ended a game on a large board early, while there were still a lot of
open spaces, it would take a long time to score (but at least the browser wouldn't freeze).
Since there are so many more legal moves that can be played if the board is mostly
empty, the Monte Carlo algorithm takes longer to finish running. And, the less complete
the game was when scoring was started, the more variance there was in the final score (due
to the random play of the Monte Carlo algorithm having more sway over the final score than the stones played by
the player). To resolve these issues, I implemented the previously mentioned area scoring
technique to be used when the game board is less than 50% full.

Area scoring would likely still benefit from dead stone removal, but rather than score
being predominantly determined by surrounded empty spaces, area scoring also
counts the number of stones that each player has on the board toward their score.
This allows me to count a more accurate score in incomplete games, where not much
territory is surrounded yet, without performing the expensive Monte Carlo simulation
to remove the dead contesting stones.

Now that I could score a game, it was finally time to make it possible to play against
another player.


## Multiplayer functionality

With my original peer-to-peer idea out the window around this time, multiplayer communication was
greatly simplified; the 2 players in a game were authenticated to make PATCH requests
to update a game model they shared in the database. A little unfortunately, I had to
duplicate all my client models to Golang + GORM in order to store them in the
database. After a little bit of work in the CRUD mines, I had a set of simple
API endpoints allowing the client to update the game state in persistent storage
after each move.

As soon as I tested it out, I noticed that while this was completely functional on
its own, you had to manually refresh the page to poll the server for any updates your
opponent may have made. This was not the UX I had envisioned (even after moving away
from peer-to-peer websockets), so I added long-polling to the client to allow it to
receive game updates as soon as they were made. I likely could have opted for
Server Sent Events instead, but it didn't come to mind, and I'm not sure if Elm
would have supported it (which would have meant more overhead from Elm ports and data
serialization going between Elm and JavaScript land). Adding long-polling to the
client was simple, since it was already equipped to handle HTTP requests asynchronously.

Implementing long-polling on the server was a little more involved, and finally let
me try out Golang channels. In the endpoint responsible for handling long-poll requests,
it creates a channel for a game model, stores it in a global map from game ID to the
channel, and then reads from the channel, effectively awaiting data to be sent over it. Then, whenever a request is made to the game update endpoint, that code checks if
there's a channel in the global map for the game ID being updated. If so, it sends the updated 
game over the channel, allowing the long-poll endpoint to respond with the latest game state.
This gave the game play page the snappy, real-time updates that I wanted for my UX.

Thanks (I guess) to my dependency injection pattern, I was able to write tests
for all that server logic, and catch some dumb bugs in my implementation ahead of time.
Unfortunately, the test validating long-poll request completion is flaky, as it will
occasionally timeout on the slower CI runner hardware before the test completes.
I "fixed" this with the classic "wait an extra few seconds" technique, sadly forcing
my test suite to wait up to 5 seconds to complete the tests of timeout behavior.


## Styling and design, I guess

Around this point of near-completion with the web app functionality, I decided I'd
better get off my ass and add some styling to the website, which had been mostly
bare HTML. I'd been interested in trying out Tailwind CSS to see
what all the fuss was about, so I cracked open the quick-start docs.

Initially, I was worried that my highly unconventional choice of Elm for the frontend
would make it more difficult to setup Tailwind, but I was pleasantly surprised that
it was a non-issue. All I had to do was point the Tailwind config at my Elm source
directory and I suppose it was able to grep all it needed from there.

Having now used Tailwind (lightly), my verdict is that it's fine. It was pretty nice to not need
to go to a separate file to write or debug styles on a component, and it also
encourages component reuse to keep the styles consistent across the app. I was a
bit surprised that it feels so different from other CSS frameworks; feeling more 
like writing CSS in the style property on each HTML tag (usually a no-no). However,
I'm not sure my little hobby project was big enough to truly grok its supposed biggest boon:
not needing to navigate and maintain a pile of custom CSS. In the end, I was 
satisfied with it. But next project I need CSS, I'll reach for something more batteries-included (like Bootstrap, or Tailwind components),
since web design and styling are NOT my passion.


## DevOps

### System Administration for dummies (me)

At last having implemented all the features I wanted for launch, it was time for me
to deploy the website! Perhaps if Heroku free-tier still existed (RIP), I would have
gone for that quick and easy route. But it's dead, and I was interested in learning
a bit more about what's under the hood in all these cloud offerings, so I went on the
hunt for the cheapest possible VPS and domain name (specifically cheap because I am a cheap-skate, and
I don't expect this project to ever need to handle much traffic) with the goal of doing things
the old-fashioned way.

Finding a cheap domain name was pretty straightforward, but certainly involved some
compromises. In the ideal world, I would have liked something like netgo.com. But such
a short, clean domain was upwards of $200/month, hence the much less sexy, but
crucially more affordable, playonlinego.xyz from namecheap.

On the VPS front, there were a lot more possibilities, from Digital Ocean droplets to 
trying to figure out how to turn some old computers at home into servers and self-hosting. 
Ultimately, I ended up with a bottom-tier VPS from RackNerd for only $10/year! I
decided on RackNerd because it offered the best balance of price for control that I
could find. It may be much more difficult to scale than something like AWS EC2 if the
need to scale ever arises, but I was more interested in doing some 
system administration (for fun and educational profit) than hedging for a scaling
event that may never come. Some future project will be unnecessarily scalable.

With VPS IP and root credentials in hand, it was finally time to SSH in and start
securing and provisioning my system. Having never setup a webserver from scratch before, a series
of [Digital Ocean blog posts](https://www.digitalocean.com/community/tutorials/recommended-security-measures-to-protect-your-servers) 
were invaluable in teaching me what that actually entailed. 
In short, the steps I took were:
1. created a new non-root user to use over ssh
2. disabled root login and required password auth for ssh
3. installed fail2ban to IP ban computers repeatedly failing ssh login attempts
4. firewalld was already installed, so I just opened up http/s connections to enable it to function as a web server

The last step was to install and configure nginx to serve over HTTPS. It wasn't too difficult,
but manually creating a cron job to run certbot was still a more involved process 
than I expected for enabling a feature as ubiquitous as HTTPS with a webserver as popular
as nginx. I suppose that's on me
for expecting every web feature we take for granted these days to have been abstracted
into 1-line configurations by now.


### Deployment and automation

In theme with my old-school sys admin provisioning, I briefly thought about deploying
my website the old-fashioned way as well; just scp or rsync my application files
to the server. However, I eventually decided that idea was too old-school, even for
my taste, as the educational opportunity seemed rather low (I would probably only
learn why we don't deploy websites that way anymore). So, to further my educational
goals, I decided to dockerize my app and run it in a container on my VPS.

Building the docker image was pretty straightforward, since all installation commands
I needed were already saved as npm run scripts for my convenient use. Once I'd
copied those into the Dockerfile, identifying the Elm build artifacts and Golang
binary was easy. I only hit 1 snag while initially making the docker image. It 
turned out that compiling the Golang server requires 
cgo (and therefore needing glibc available as a dynamic library on the end image) 
due to GORM database driver dependencies. But glibc wasn't available in the musl-based
alpine linux image I was using to minimize the resources my docker image would need
on my extremely low-end VPS. Luckily, I was able to find someone's slightly modified
version of the alpine image
that included glibc, so that I wouldn't have to use a heavier image, like ubuntu, as
the base for my docker image.

With the docker image working locally, I was ready start running my containerized
app on my VPS, and automate the whole deployment process. I've really fallen in love
with doing CI/CD automation, so this part was a ton of fun for me (even if I have a
bit of a love/hate relationship with GitHub Actions). I already have a (poorly documented) 
[library of general purpose GitHub Actions](https://github.com/niehusst/shared-actions) 
that I've used in other projects to automate releases and deployment, so I grabbed
actions for enforcing conventional commits and semantic versioned GitHub release and
tagging. Then I had to create one new action to build a new version of my docker image
from code at a specified commit tag, and tag the new image with the same name as the
semantic versioned git tag. And another new action to ssh into my VPS, stop and remove
the running version of the app in docker, pull new image tags, and start a new container
with the specified tag. Lastly, I just had to define a new GitHub Actions workflow to
allow me to run those actions at the click of a button, and on every GitHub release.
After only a few days of debugging (since GitHub Actions forces you to commit and push
everything to even check if the yaml schema is valid) I had a functional pipeline,
and v1 of my site was deployed to my VPS and accessible for all the internet to see!
The next logical step was debugging in production. :)

So the careful reader may have discerned that I was only running a single container,
and that I'd been using sqlite as my database. This obviously is not a good recipe
for "persistent" storage, as every time you start a new container, it would start
with its own empty copy of the sqlite database, effectively wiping the database on each
deployment. Now, I knew this ahead of time, so I thought I'd solved the problem by
adding a volume to the container when I started it up, to persist my database
across container instances. Indeed, this did solve the
problem of the sqlite database file being overwritten on each deploy, but it also had the
unintentional consequence of the rest of my application files also not being overwritten
on deployment. For a couple days, my incorrect assumption that the volume
would only persist new files created while the container was running, tested my
sanity, as the entire contents of my docker image (and all included app code) was persisted
across deployments, regardless of my app's version.

Having finally learned the source of my docker deployment troubles, I decided it was
time I followed the standard advice to run you database in a separate container,
and therefore avoid the docker volume foot-gun. I didn't have any desire to switch
databases, but it just felt silly trying to use sqlite across containers. There
isn't really anything to containerize for sqlite, since it doesn't have any server
component (all the database logic is included in the application's sqlite library).
So I just switched to MariaDB.

Using MariaDB was more work than sqlite, since I had to create a user to
access the database. But this was more of a challenge to setup for local dev than
it was in docker, since the official MariaDB image allows you to specify a user to create
when a container starts. And only minor changes to the Golang code was necessary to
make it work, mainly just switching out the GORM drivers, and changing a database
field type for one of my custom model types, since MariaDB requires VARCHAR to have
a specified length, whereas sqlite does not. That last change took some time to figure
out because the type error message (which I later figured out I wrote in my GORM
custom model Scanner function... oops) didn't contain enough info to help me debug it.

After adapting my deployment script to use docker compose to spin up and down my now
2 containers, all was finally functional. I can now deploy changes to my web app
at the click of a button, all without breaking my database! Continuous Deployment bliss.


## Conclusion

Wow, this project has been a long ride of start-and-stop development. I still wish it
hadn't taken 2.5 years to complete the MVP, but that's just how the cookie crumbled.
But now it's finally out there!

I've gotten to test the website out with some
friends and teach them how to play Go. There are plenty of rough edges, but overall, I'm proud of what
I've built; you can certainly play Go online with it. I briefly thought about posting
it to hackernews, but then I remembered how small of a VPS it's running on and thought
better of it.

There's definitely more that could be improved (server-side validation, the design, accessibility, mobile UI optimizations, analytics, observability, DB backups, make it scalable).
But for now, I'm happy with where the project is at, and will likely pick up
a new project to work on instead.

If you have any interest in playing some Go (and have a friend to play with, since there's no AI
to play against), feel free to give it a try!
