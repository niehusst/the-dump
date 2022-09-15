---
layout: post
title:  "iOS Binary xcframeworks"
background: "/assets/imgs/bikedump.jpg"
---

I'm writing about xcframeworks today because they've been giving me a lot of headaches at work recently and I wanted to save some notes for myself for the next time I might use xcframeworks.

### So what are they?

An xcframework basically a type of bundle for Swift/Obj-C binaries introduced at WWDC 2019. They allow for multiple Frameworks (aka binary bundle of a program) to bundled together and released as a single unit; this is because a weakness of the earlier Framework format was that each Framework could only be for 1 hardware architecture, so releasing the same code to multiple arches was a bit of hassle because you had to juggle multiple binaries (this was more of an issue when iOS architecute was still in the process of transitioning from armv7 to arm64).

So xcframeworks are pretty convenient, and at WWDC 2021, Apple allowed Swift Packages to be released as binary packages through SPM (yay closed source). 

### But how do you make 'em?

That's the real question. In my research, apple's official docs where pretty garbage, so I had to figure it out through endless internet research and trial and error.

(I'll be walking through the important bits of [this bash file](https://github.com/niehusstaab/StaticLibDemo/blob/main/bin/build-xcframework) I helped make for automating xcframework creation.)

First of all, at the time or writing this, creating an xcframework from a Swift Package isn't really possible: there has to be an xcodeproj (or xcworkspace) defining a Framework target in order to compile an xcframework. There are some tools that can generate and xcodeproj from a Swift Package, but none of them worked out of the box for me.

Once you have an xcodeproj and a Framework target, the first step is actually project settings (exciting). If you don't have your project settings exactly correct, you won't be able to build an xcframework (the archiving step might produce an object file `.o` instead!). You must have `SKIP_INSTALL` set to No and `BUILD_LIBRARY_FOR_DISTRIBUTION` set to Yes in order to generate an xcframework (and enable library evolution, so that your binary works (in theory) across swift versions). Then you have to select your `Mach-O` binary type as either a static or dynamic library. I won't go over the differences between those here, but an important difference that isn't talked about much is that static libs can't have resources bundled into them (technically the resource files can be copied over, but are then inaccessible anyway)! If your package contains any resource files (images, fonts, JSON) that you want your code to have access to in production, you will need to choose dynamic library, or do some heavy refactoring.

The first real step of building an xcframework is to archive your code to a Framework binary.
```
xcarchive_path="$archive_root/$SCHEME-$sdk.xcarchive"

xcodebuild \
    -workspace $workspace_name \     # alternatively, this could be -project $project_name
    -scheme "$SCHEME" \              # name of the Xcode scheme to compile (your framework target name)
    -configuration $configuration \  # Debug or Release
    -archivePath $xcarchive_path \   # specify the path to write the xcarchive to (you do have to specify a path, not necessarily a full file name like here)
    -derivedDataPath $build_path \   # (optional) path to build cache
    -sdk $sdk \                      # OS sdk to compile for (e.g. "iphoneos")
    -scmProvider system \            # (optional) Source Control Manager specification
    -showBuildTimingSummary \        # (optional) flag to show extra info
    archive                          # specifying the `archive` command to build an archive of the framework
```
You will probably create at least a couple framework archives in this fashion (though you don't have to) to take advantage of xcframework being able to contain multiple frameworks. Often times, you create a framework for iphoneos and iphonesimulator sdks so that the same binary can be used in physical devices for prod and simulators for development. Then, you take however many frameworks you archived and create the xcframework.
```
xcodebuild \
    -create-xcframework \                   # command to create an xcframework
# repeat this collection of args for each framework you want to include
    -archive $xcarchive_path                # path to the created archive. Can be full file path to framework, or just path to xcarchive directory
    -framework $framework_name              # (optional) if you provided path to only xcarchive directory, then you must include the framework name here
    -debug-symbols $xcarchive_path/dSYMs"   # (optional) path to dSYM files if you want those included in the xcframework
# end repeatable chunk
    -output $xcframework_output             # specify where to output the xcframework to
```
You've done it! You should now have a functional xcframework ready for deployment/use.

As a final note: be congnizant of binary dependencies in your code, if they dont support an arch you are trying to compile to, you cant compile for that arch either. If you try, your build will fail with a message like `error: "import SomeBinaryPackage" no such module "SomeBinaryPackage"` even though you definitely have it installed. That is because when the compiler reaches into SomeBinaryPackage to retrieve the binary files for the arch they don't support (e.g. iphonesimulator arm64), it can't find them, hence no such module. The reason someone might do this (although they shouldn't) is because iphonesimulator arm64 arch didn't exist before M1 macs came out, and its sudden creation caused xcframework build errors for some people, so a hacky solution some people used was just to exclude that architecture from the released xcframeworks.

### So I've got one. Now what do I do?

I've only used xcframeworks in the context of internal packages released through SPM or CocoaPods, but I think that's the main use case (who wants to drag and drop your package into Xcode anyway?).

In SPM, you can simply use the `binaryTarget` function in place of the typical `target` function to define your library target. In Swift 5.6 (Xcode 13.3+) you can provide a repo local path or a URL to a zip file containing you xcframework. If you want to use local path prior to Xcode 13.3 though, you have to commit the whole unzipped xcframework (they be chonky) to your repo since pointing to a zip file wasn't supported yet.

In CocoaPods, you have to find somewhere to host your xcframework since the podspec file has to point to a URL where the binary can be found at during pod install. Artifactory could be a good option for that (I think it's free for hobby tier?).
