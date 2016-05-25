#!/usr/bin/env jruby
# :title: PlanR::Plugins::Shared::Lucene::Document
=begin rdoc
(c) Copyright 2016 Thoughtgang <http://www.thoughtgang.org>
NOTE: This module should only be loaded in a JRuby process.
=end

require 'plan-r/plugins/shared/jruby/lucene/core'

# =============================================================================
module Lucene

  module Doc
    include_package 'org.apache.lucene.document'

    FIELD_ID = 'id'
    FIELD_BODY = 'body'
    FIELD_TITLE = 'title'
    FIELD_AUTHOR = 'author'
    # keywords? other metadata?

    def self.create_document(id, text, properties)
      d = Document.new
      d.add( Field.new(FIELD_ID, id, Field::Store::YES, 
                       Field::Index::NO) )
      d.add( Field.new(FIELD_BODY, text, Field::Store::YES, 
                       Field::Index::ANALYZED) )
      # TODO: if doc.title...
      #       origin?
      d
    end

  end
end
