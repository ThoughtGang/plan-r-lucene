#!/usr/bin/env ruby
# :title: PlanR::Plugins::LuceneSimple
=begin rdoc
=Lucene Plugins
(c) Copyright 2016 Thoughtgang <http://www.thoughtgang.org>

Convenience methods which wrap Server.invoke() and provide access to Lucene
tokenizer, analyzers, and so forth.
=end

require 'drb'
require 'thread'

require 'plan-r/application/jruby'
require 'plan-r/plugins/shared/lucene/server'

module PlanR
  module Plugins
    module Lucene

      module Index

        def self.lucene_tokenize(text, analyzer, args)
          Lucene::Server.invoke(:tokenize_document, :text => text, 
                                :tokenizer => analyzer, :tokenizer_args => args)
        end

        def self.lucene_index(path, id, text, properties, analyzer, args)
          Lucene::Server.invoke(:index_document, :index_path => path, 
                                :doc_id => id, :text => text,
                                :properties => properties,
                                :analyzer => analyzer, :analyzer_args => args)
        end

        def self.lucene_query(path, query, analyzer, args)
          Lucene::Server.invoke(:query_index, :index_path => path, 
                                :query => query.to_json,
                                :analyzer => analyzer, :analyzer_args => args)
        end

        def self.lucene_related_docs(path, doc)
          kwds = Lucene::Server.invoke(:keyword_stats, :index_path => path)
          h = (kwds || {}).reject { |k,v| ! (v.include? doc.path) }
          PlanR::RelatedDocuments.from_keyword_stats(h)
        end

        def self.lucene_keywords(path, h)
          fn = h[:stats] ? :keyword_stats : :keywords
          Lucene::Server.invoke(fn, :index_path => path)
        end

      end
    end
  end
end
