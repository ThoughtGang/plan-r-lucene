#!/usr/bin/env jruby
# :title: PlanR::Plugins::Shared::Lucene::Tika::Core
=begin rdoc
(c) Copyright 2016 Thoughtgang <http://www.thoughtgang.org>

WARNING: This code only executes in JRuby!                                      
=end

# This module cannot be loaded unless JRuby is the interpreter
raise ScriptError.new("Lucene requires JRuby") unless RUBY_PLATFORM =~ /java/

require 'plan-r/plugins/shared/jruby/tika/core'

require 'java/tika-app.jar'

# =============================================================================
=begin rdoc
Wrapper for Tika parser library.
=end
module Tika

  module ContentHandler
    Body = Java::org.apache.tika.sax.BodyContentHandler
    Boilerpipe = Java::org.apache.tika.parser.html.BoilerpipeContentHandler
    Writeout = Java::org.apache.tika.sax.WriteOutContentHandler
  end

  module Parser
    Auto = Java::org.apache.tika.parser.AutoDetectParser
  end

  module Detector
    Default = Java::org.apache.tika.detect.DefaultDetector
    Language = Java::org.apache.tika.language.LanguageIdentifier
  end

  Metadata = Java::org.apache.tika.metadata.Metadata

=begin rdoc
Parse the String using AutoDetectParser
=end
  def self.parse(str)
    ensure_language_init

    begin
      input = java.io.ByteArrayInputStream.new(str.to_java.get_bytes)
      content = ContentHandler::Body.new(-1)
      metadata = Metadata.new

      Parser::Auto.new.parse(input, content, metadata)
      lang = Detector::Language.new(input.to_string)

      { :content => content.to_string, 
        :language => lang.getLanguage(),
        :metadata => metadata_to_hash(metadata) }
    rescue Exception => e
      $stderr.puts "Error in Tika::Parse: #{e.message}"
      { :error => e.message }
    end
  end

  def self.metadata_to_hash(mdata)
    h = {}
    Metadata.constants.each do |name| 
      begin
        val = mdata.get(Metadata.const_get name)
        h[name.downcase.to_sym] = val if val
      rescue NameError
        # nop
      end
    end
    h
  end

  @@language_init = false
  def self.ensure_language_init
    # if not already done...
    if ! @@language_init
      Detector::Language.initProfiles
      @@language_init = true
    end
  end

end
