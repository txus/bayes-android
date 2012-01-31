# bayes-android

A simple [Bayes network](http://en.wikipedia.org/wiki/Bayesian_network)
simulator for Android written in [Mirah](http://mirah.org). It's a work in
progress AND I'm an Android noob, so don't expect anything usable just yet! :P

## Building

You'll need the development version of Pindah to build this. Get it like this:

    rvm use jruby-head
    gem install mirah

    git clone git://github.com/mirah/pindah.git
    cd pindah && gem build pindah.gemspec && gem install pindah-0.1.3.dev.gem

Now for the actual app:

    git clone git://github.com/txus/bayes-android
    cd bayes-android
    rake debug

Now to install and run your app in either the simulator or a real device, type:

    adb install bin/bayes-debug.apk && adb logcat

To make the whole cycle more agile, I've set up a `build.sh` that cleans the
build, uninstalls the app from the device, builds it again, installs it, and
starts logging. Useful while developing:

    ./build.sh

## Who's this

This was made by [Josep M. Bach (Txus)](http://txustice.me) under the MIT
license. I'm [@txustice](http://twitter.com/txustice) on twitter (where you
should probably follow me!).
