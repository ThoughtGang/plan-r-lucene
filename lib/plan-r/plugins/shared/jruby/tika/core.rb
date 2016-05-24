#!/usr/bin/env jruby
# :title: PlanR::Plugins::Shared::Lucene::Tika
=begin rdoc
(c) Copyright 2016 Thoughtgang <http://www.thoughtgang.org>

WARNING: This code only executes in JRuby!
=end

# Bail out early unless invoked under JRuby
raise ScriptError.new("Lucene requires JRuby") unless RUBY_PLATFORM =~ /java/

require 'java'

class JRubyDaemon

=begin rdoc
Parse a document using Tika.
Expected arguments:
  :contents : raw binary/ascii data to parse
=end
  def tika_parse_contents(args)
    begin
      # NOTE: Tika.parse is defined in shared/jruby/tika/parse
      Tika.parse( args[:contents] || '' )
    rescue Exception => e
      $stderr.puts "ERROR in Tika.parse"
      $stderr.puts e.message
      {}
    end
  end

end
