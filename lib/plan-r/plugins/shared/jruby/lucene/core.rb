#!/usr/bin/env jruby
# :title: PlanR::Plugins::Shared::Lucene::Core
=begin rdoc
(c) Copyright 2016 Thoughtgang <http://www.thoughtgang.org>
NOTE: This module should only be loaded in a JRuby process.
=end

# TODO:
#   docFreq(Term t) [# of docs w term t]
#   numDocs()

# Bail out early unless invoked under JRuby
raise ScriptError.new("Lucene requires JRuby") unless RUBY_PLATFORM =~ /java/

# =============================================================================
# LUCENE Core module

require 'java/lucene-core.jar'
require 'plan-r/plugins/shared/lucene/settings'

module Lucene
  Version = org.apache.lucene.util.Version
end 

# =============================================================================
# JRubyDaemon extensions

require 'plan-r/datatype/query'
require 'json/ext'

class JRubyDaemon

=begin rdoc
Index document. This deletes all existing instances of document in index.

Expected arguments:
  :index_path
  :analyzer
  :analyzer_args
  :doc_id
  :text
  :properties
=end
  def index_document(args)
    begin
      idx = Lucene::Index.writer(args[:index_path], args[:analyzer],
                                 args[:analyzer_args])

      # delete document if it already exists in index
      idx.deleteDocuments( Lucene::Index::Term.new('id', args[:doc_id]) )

      idx.addDocument(Lucene::Doc.create_document( args[:doc_id], args[:text], 
                                                   args[:properties] ))
      idx.close
      true
    rescue Exception => e
      $stderr.puts "ERROR in Lucene.index_doc"
      $stderr.puts e.message
    end
  end

=begin rdoc
Remove document from index. Note that this performs a commit.

Expected arguments:
  :index_path
  :analyzer
  :analyzer_args
  :doc_id
  :text
  :properties
=end
  def remove(args)
    begin
      idx = Lucene::Index.writer(args[:index_path], args[:analyzer],
                                 args[:analyzer_args])

      # delete document if it already exists in index
      idx.deleteDocuments( Lucene::Index::Term.new('id', args[:doc_id]) )

      idx.commit
      idx.close
    rescue Exception => e
      $stderr.puts "ERROR in Lucene.index_doc"
      $stderr.puts e.message
    end
  end


  # ----------------------------------------------------------------------
  # Analysis

=begin rdoc
Return an Array of tokens (String) for document.

Expected arguments:
  :tokenizer
  :tokenizer_args
  :text

Note: this may have to take additional args to pass to 
Tokenizer.tokenize_document, e.g. a hash of field to index.
This may mean args[:text] is replaced by args[:fields] => { :text => ... } etc
=end
  def tokenize_document(args)
    begin
      Lucene::Tokenizer.tokenize_document(args[:text], args[:tokenizer],
                                          args[:tokenizer_args])
    rescue Exception => e
      $stderr.puts "ERROR in Lucene::Tokenizer.tokenize_document"
      $stderr.puts e.message
      []
    end
  end

  # ----------------------------------------------------------------------
  # Search
=begin rdoc
  :index_path
  :query
  :analyzer
  :analyzer_args
=end
  def query_index(args)
    begin
      idx = Lucene::Index.searcher(args[:index_path])

      query = JSON.parse(args[:query])

      # TODO: query parser type, more fields
      parser = Lucene::Index.query_parser(query.fields.first, 
                                          args[:analyzer],
                                          args[:analyzer_args])

      # TODO: something more sophisticated
      idx_query = parser.parse(query.terms.join(" "))

      top_docs = idx.search(idx_query, query.max_results)
      # TODO: is any of topDocs worth keeping?
#$stderr.puts top_docs.totalHits.to_s
#$stderr.puts "%0.4f" % top_docs.getMaxScore

      results = []
      top_docs.scoreDocs.each do |score_doc|
        doc = idx.doc(score_doc.doc)

        r = PlanR::Query::Result.new(doc.get('id'), score_doc.score )
        # TODO: r.add_term(term, field, [pos])
        # TODO: other document metadata, e.g. title and such

        results << r
      end
      results

    rescue Exception => e
      $stderr.puts "ERROR in Lucene::Index::query_index"
      $stderr.puts e.message
      {}
    end
  end

=begin rdoc
Return list of keywords used in index

Expected arguments:
  :index_path
=end
  def keywords(args)
    idx = Lucene::Index.reader(args[:index_path])

    results = []
    terms = idx.terms()
    while terms.next
      term = terms.term
      results << term.text # term contains field and text
    end
    results
  end

=begin rdoc
Return keyword statistics.
This returns a Hash [ String -> Hash ] mapping keywords to a 
Hash [ String -> Hash [:frequency, :positions] ] that associates a document
ID (path) with a frequency count and a list of positions (occurences in the
document) for the term.

Expected arguments:
  :index_path
=end
  def keyword_stats(args)
    idx = Lucene::Index.reader(args[:index_path])

    results = {}
    terms = idx.terms()
    while terms.next
      term = terms.term

      h = {}
      term_pos = idx.termPositions(term)
      while term_pos.next
        freq = term_pos.freq
        positions = []
        freq.times { positions << term_pos.nextPosition() }
        doc = idx.document(term_pos.doc)
        h[doc.get('id')] = { :frequency => freq, :positions => positions }
      end

      results[term.text] = h
    end
    results
  end

end
