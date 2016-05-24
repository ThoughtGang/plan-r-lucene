#!/usr/bin/env jruby
# :title: PlanR::Plugins::Shared::Lucene::Query
=begin rdoc
(c) Copyright 2016 Thoughtgang <http://www.thoughtgang.org>
NOTE: This module should only be loaded in a JRuby process.
=end

#java_import org.apache.lucene.queryParser.ParseException
#java_import org.apache.lucene.queryParser.QueryParser
#java_import org.apache.lucene.search.TopScoreDocCollector
#java_import org.apache.lucene.search.TopScoreDocCollector

require 'java/lucene-core.jar'
require 'plan-r/plugins/shared/lucene/settings'

# =============================================================================
module Lucene

  module Search
    #java_import org.apache.lucene.search.IndexSearcher
    include_package 'org.apache.lucene.search'

    # TermQuery  new TermQuery(new Term("fieldName", "term"));
    # BooleanQuery -- build piece by piece 
    # PhraseQuery -- Ditto. .add() etc.
    # SpanNearQuery SpanNearQuery(SpanQuery[] clauses, int slop, boolean inOrder) 
    # TermRangeQuery TermRangeQuery(String field, String lowerTerm, String upperTerm, boolean includeLower, boolean includeUpper) 
    # NumericRangeQuery NumericRangeQuery.newFloatRange("weight",
    # new Float(0.3f), new Float(0.10f), true, true);
    # PrefixQuery
    # WildCardQuery
    # FuzzyQuery FuzzyQuery(Term term, float minimumSimilarity, int prefixLength) 
    # MultiFieldQueryParser(Version matchVersion, String[] fields, Analyzer analyzer, Map boosts)
    # TODO: query class
    # String querystr = args.length > 0 ? args[0] : "lucene";
    #Query q = new QueryParser(Version.LUCENE_34, "title", analyzer).parse(querystr);
    # int hitsPerPage = 10;
    #IndexSearcher searcher = new IndexSearcher(index, true);
    #TopScoreDocCollector collector = TopScoreDocCollector.create(hitsPerPage, true);
    #searcher.search(q, collector);
    #ScoreDoc[] hits = collector.topDocs().scoreDocs;
    # System.out.println("Found " + hits.length + " hits.");
    #for(int i=0;i<hits.length;++i) {
    # int docId = hits[i].doc;
    # Document d = searcher.doc(docId);
    # System.out.println((i + 1) + ". " + d.get("title"));
    # }

    # involves creating a Query (usually via a QueryParser) and handing this Query to an IndexSearcher, which returns a list of Hits.
    #searcher = Lucene::Search::IndexSearcher.new(Lucene::Store::FSDirectory.open(java.io.File.new('test.index')));
    #t = Lucene::Index::Term.new("title", "some");
    #query = Lucene::Search::TermQuery.new(t);
    #docs = searcher.search(query, 10);
    #docs.totalHits.times do |i|
    #  puts searcher.doc(docs.scoreDocs[i].doc).get("title")
    #end
    ## get the term frequencies of a term
    #reader = Java::OrgApacheLuceneIndex::IndexReader.open(index)
    #t = org.apache.lucene.index.Term.new("title", "some")
    #freqs = reader.term_docs(t)
    #term_count = 0
    #while(freqs.next)
    #  term_count = term_count + freqs.freq
    #end
  end

  module Query
    include_package 'org.apache.lucene.queryParser'
  end

end
