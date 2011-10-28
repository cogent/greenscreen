GreenScreen
===========

GreenScreen is a build monitoring tool that is designed to be used as a dynamic Big Visible Chart (BVC) in your work area.  It lets you add links to your build servers and displays the largest possible information on a monitor so that the team can see the build status from anywhere in the room.

Getting Started
---------------

GreenScreen can be used to monitor jobs on any build server that publishes a information in "CruiseControl Multiple Project Summary Reporting Standard" format:

  http://confluence.public.thoughtworks.org/display/CI/Multiple+Project+Summary+Reporting+Standard

This includes Jenkins/Hudson, as well as all variants of CruiseControl.

Create a "greenscreen.yml" file, to tell GreenScreen which servers you want to monitor:

    # all jobs from the local Jenkins server
    sources:
      -
        url: http://localhost:8080/cc.xml

Now, start GreenScreen with

     greenscreen -c greenscreen.yml

This start a web-server listening on (by default) port 3000.  Point your browser at http://localhost:3000 to see thestatus of all of your builds.  The screen will refresh every 15 seconds to keep itself up to date.

NOTE: GreenScreen is set up so that the name of the project will flash when it is building, but neither Safari nor IE support blinking text.  You probably want to use Firefox to get the most value out of it.

If running on Windows, I'd suggest running Firefox in full screen mode.  If on a Mac, either expand the window size to take up as much space as possible, or try finding a plugin that lets you go full screen.
