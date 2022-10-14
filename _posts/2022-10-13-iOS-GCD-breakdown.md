---
layout: post
title:  "iOS GCD breakdown"
background: "/assets/imgs/fooddump.jpg"
---

(This post is basically a sparknotes of a series of [medium posts](https://medium.com/@almalehdev/concurrency-visualized-part-1-sync-vs-async-c433ff7b3ebe)
 by Besher Al Maleh. Support the original author over my summary of their words!)

Concurrency is very important to many systems and frameworks, and iOS development
is no exception. With iOS 15, we recently got some new tools in the form of the
familiar async/await pattern. But I'm not going to talk about those because those
are easier for me to remember than the old DispatchQueue APIs. Really, this post
is a note to myself to help remember some of the key points of the DispatchQueue
APIs and Grand Central Dispatch (GCD).

### System queues and task priority

GCD is Apple's scheduler for handling concurrency tasks in iOS. It uses queues to
hold tasks with some extra settings to help determine how to schedule those tasks.
The most important work queue is the main queue (aka main thread). This is where
all UI work is done, and where all other concurrency tasks are spawned from. The
main queue is serial, meaning every task is executed in the order it was placed in
the queue (typical queue behavior).

The global queue is Apple's system provided DispatchQueue for async tasks. It is
a concurrent queue, meaning that each task put on the queue will be run whenever
the OS decides to, based on the priority of the task. This could mean a task you
put on the queue could start running immediately, or could hypothetically never
be run if the OS receives higher priority tasks continuously. You can influence
the priority of tasks you put on a queue by providing a Quality of Service
(QoS) setting when you add your task to the queue. Those settings are:
1. `.userInteractive` highest priority. For tasks that will eventually update UI interactively (e.g. animations)
2. `.userInitiated` high priority. For something user triggered and wants done asap
3. `.default` medium priority. For work done on user's behalf 
4. `.utility` low priority. For long tasks that don't block a user from using the app
5. `.background` lowest priority. For non-essential things users dont need to know anything about

I was confused for a while how you would use a QoS for a background thread that is
recommended for updating UI, like `.userInteractive`, but I realized the expected
use case must be something like:
```swift
DispatchQueue.global(qos: .userInteractive).async {
  // do some work we dont want to block main thread, like
  // heavy duty calculations for animations???
  DispatchQueue.main.async {
    // send result of work back to main to update UI
  }
}
```
If you're planning to do a lot of work repeatedly, it might be a better idea to create your
own dispatch queue rather than using the global queue, since the global queue could
be weighed down with tasks from the iOS framework or even other apps. Making your own queue
makes it more likely for your work to be scheduled in a timely manner. You can also use
these QoS in your own DispatchQueues if you need task prioritization too.

### Scheduling and blocking

Now we get to the core, harder for me to remember parts of DispatchQueue: sync vs async and serial vs concurrent.

`sync` blocks the calling thread until the work block is done executing, whether or not the work
actually executed on the calling thread.
`async` does not block the calling thread, so any code after a call to `async` will be executed
immediately after the task is placed on the queue.

```swift
DispatchQueue.global().sync {
  print("run first")
}
print("I have to wait")

DispatchQueue.global().async {
  print("I'll run whenever")
}
print("I'll probably run before the async task, but no guarantees")
```

Serial queues execute tasks from start to finish in the order they were added to the queue.
Concurrent queues begin tasks in the order they were added to the queue, but do not wait for the
tasks to finish before beginning the next task. Concurrent queues spawn new threads as necessary
to begin the work as quickly as possible.

```swift
let qSerial = DispatchQueue(label: "qname1", attributes: .serial) // serial is default if you don't specify
let qConcur = DispatchQueue(label: "qname2", attributes: .concurrent)

let waitTimes = [1, 2, 3]

func waitFor(_ n: Int) { /* pretend we wait for n seconds */ }

for seconds in waitTimes {
  qSerial.async { waitFor(seconds) }
  qConcur.async { waitFor(seconds) }
}

// qSerial will take 6 seconds to complete all tasks
// qConcur will take 3 seconds to complete all tasks
```

In short, sync/async affects the calling thread, whereas serial/concurrent affects the receiving thread
(that will actually run the task).
