#!/usr/bin/env ruby
# :title: PlanR::Plugins::Parser::Tika
=begin rdoc
=Tika parser plugin
(c) Copyright 2016 Thoughtgang <http://www.thoughtgang.org>

Requires DRb JRuby bridge for Lucene.
=end

require 'tg/plugin'
require 'plan-r/application/jruby'

module PlanR
  module Plugins

    module Parse

=begin rdoc
Tike file type identification plugin.
=end
      class Tika
        extend TG::Plugin
        name 'Tika Parser'
        author 'dev@thoughtgang.org'
        version '1.0'
        description 'Parse a document with the Tika library'
        help 'Tika detects and extracts metadata and structured text content from various documents using existing parser libraries.
Note: Requires JRuby.'

=begin rdoc
Parse document using Tika. 
This returns a ParsedDocument object for the provided document.
=end
        def parse(doc)
          return nil if (! PlanR::Application::JRuby.running?) 
          begin
            h = tika_parse(doc.contents)

            pdoc = PlanR::ParsedDocument.new(name, doc)
            pdoc.add_text_block (h[:content] || '')
            pdoc.properties[:language] = h[:language]
            (h[:metadata] || {}).each { |k,v| pdoc.properties[k] = v }
            pdoc
          end
        end
        spec :parse_doc, :parse, 40 do |doc|
          next 0 if (! PlanR::Application::JRuby.running?) 
          # TODO: figure out suitability of Tika
          40
        end

        def ident(data, fname)
          h = tika_parse(data)
          mime_type, encoding = h[:metadata][:content_type].split('; charset=')
          # FIXME: better way to get ident data (e.g. summary) out of tika?
          PlanR::Ident.new(mime_type, encoding, h[:language], '', '')
        end
        spec :ident, :ident, 50

        private
        def tika_parse(str)
          conn = PlanR::Application::JRuby.connect
          return {} if (! conn)

          # JRubyDaemon.tika_parse_contents is defined in 
          #   plan-r/plugins/shared/jruby/tika/core
          h = conn.tika_parse_contents( :contents => str )
          PlanR::Application::JRuby.disconnect
          h
        end
        PlanR::Application::PluginManager.blacklist(canon_name) if ! \
                                              PlanR::Application::JRuby.running?
      end
    end

  end
end
