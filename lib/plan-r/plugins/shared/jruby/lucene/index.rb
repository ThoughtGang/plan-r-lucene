#!/usr/bin/env jruby
# :title: PlanR::Plugins::Shared::Lucene::Index
=begin rdoc
(c) Copyright 2016 Thoughtgang <http://www.thoughtgang.org>
NOTE: This module should only be loaded in a JRuby process.
=end

require 'java/lucene-core.jar'
require 'plan-r/plugins/shared/lucene/settings'

# =============================================================================
module Lucene

  module Store
    include_package 'org.apache.lucene.store'
  end

  module Index
    include_package 'org.apache.lucene.index'

    # In general: index based on type of data. Each type of search/data has 
    # its own index. Combine all indexed fields into an uber field like
    # 'contents' to maxmize chance of a hit

    def self.instantiate_index(path)
      Store::FSDirectory.open(java.io.File.new(path))
    end

    def self.reader(path)
      IndexReader.open(instantiate_index(path))
    end

    def self.writer(path, analyzer=:standard, analyzer_args=[])
      index = instantiate_index(path)
      obj = Tokenizer.instantiate_tokenizer(analyzer, analyzer_args || [])
      IndexWriter.new(index, obj, IndexWriter::MaxFieldLength::UNLIMITED)
    end

    def self.searcher(path)
      Search::IndexSearcher.new(instantiate_index(path))
    end

# TODO: parser = TermQuery, BooleanQuery, PhraseQuery, PrefixQuery, RangeQuery,
# MultiTermQuery , FilteredQuery, SpanQuery, WildcardQuery, FuzzyQuery, 
# QueryParser  
    def self.query_parser(field, analyzer=:standard, analyzer_args=[])
      obj = Tokenizer.instantiate_tokenizer(analyzer, analyzer_args || [])
      Query::QueryParser.new( Lucene::Version::LUCENE_CURRENT, field, obj)
    end

  end
end
