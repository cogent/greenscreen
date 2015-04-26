# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "greenscreen/version"

Gem::Specification.new do |s|

  s.name        = "greenscreen"
  s.version     = GreenScreen::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marty Andrews", "Mike Williams"]
  s.email       = ["marty@cogentconsulting.com.au", "mike@cogentconsulting.com.au"]
  s.homepage    = ""
  s.summary     = "Makes the status of your builds highly visible"
  s.description = <<EOT
GreenScreen is a build monitoring tool that is designed to be used as a dynamic Big Visible Chart (BVC) in your work area.  It displays the status of builds from one or more build servers on a monitor, so that the team can see the status from anywhere in the room.
EOT

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "sinatra", "~> 1.4"
  s.add_runtime_dependency "thin"
  s.add_runtime_dependency "clamp", "~> 0.6.1"
  s.add_runtime_dependency "hashie", "~> 3.4.1"

end
