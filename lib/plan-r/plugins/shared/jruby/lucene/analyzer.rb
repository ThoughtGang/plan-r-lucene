#!/usr/bin/env jruby
# :title: PlanR::Plugins::Shared::Lucene::Analyzer
=begin rdoc
(c) Copyright 2016 Thoughtgang <http://www.thoughtgang.org>

Note: This refers to objects in Lucene that act as PlanR document analyzers, not
as Lucene analyzers (which are really tokenizers).

NOTE: This module should only be loaded in a JRuby process.
=end

require 'java/lucene-core.jar'
require 'plan-r/plugins/shared/lucene/settings'

# =============================================================================
module Lucene

=begin rdoc
=end
  module Analyzer
    # Built-in Lucene Analyzers
    #Arabic = org.apache.lucene.analysis.ar.ArabicAnalyzer
    #Brazilian = org.apache.lucene.analysis.br.BrazilianAnalyzer
    #Chinese = org.apache.lucene.analysis.cn.ChineseAnalyzer
    #CJK = org.apache.lucene.analysis.cjk.CJKAnalyzer
    Collation = org.apache.lucene.collation.CollationKeyAnalyzer
    #Czech = org.apache.lucene.analysis.cz.CzechAnalyzer
    #Dutch = org.apache.lucene.analysis.nl.DutchAnalyzer
    #French = org.apache.lucene.analysis.fr.FrenchAnalyzer
    #German = org.apache.lucene.analysis.de.GermanAnalyzer
    #Greek = org.apache.lucene.analysis.el.GreekAnalyzer
    #ICUCollation = org.apache.lucene.collation.ICUCollationKeyAnalyzer
    Keyword = org.apache.lucene.analysis.KeywordAnalyzer
    #Pattern = org.apache.lucene.analysis.miscellaneous.PatternAnalyzer
    #Persian = org.apache.lucene.analysis.fa.PersianAnalyzer
    # for removing common words from queries:
    #QueryAutoStopWord=org.apache.lucene.analysis.query.QueryAutoStopWordAnalyzer
    #Russian = org.apache.lucene.analysis.ru.RussianAnalyzer
    Simple = org.apache.lucene.analysis.SimpleAnalyzer
    #SmartChinese = org.apache.lucene.analysis.cn.smart.SmartChineseAnalyzer
    #Snowball = org.apache.lucene.analysis.snowball.SnowballAnalyzer
    Standard = org.apache.lucene.analysis.standard.StandardAnalyzer
    Stop = org.apache.lucene.analysis.StopAnalyzer
    #Thai = org.apache.lucene.analysis.th.ThaiAnalyzer
    Whitespace = org.apache.lucene.analysis.WhitespaceAnalyzer
    # TODO: instances of Custom Analyzer
    # NOTE: this could be run on a repo-open to use per-repo paths
    #  Analyzer ana = CustomAnalyzer.builder(Paths.get("/path/to/config/dir"))
    # .withTokenizer("standard")
    # .addTokenFilter("standard")
    # .addTokenFilter("lowercase")
    # .addTokenFilter("stop", "ignoreCase", "false", "words", "stopwords.txt", "format", "wordset")
    # .build();

    ANALYZERS = {
      #:arabic => Arabic,
      #:brazilian => Brazilian,
      #:chinese => Chinese,
      #:cjk => CJK,
      :collation => Collation,
      #:czech => Czech,
      #:dutch => Dutch,
      #:french => French,
      #:german => German,
      #:greek => Greek,
      #:icu_collation => ICUCollation,
      :keyword => Keyword,
      #:pattern => Pattern,
      #:persian => Persian,
      #:query_auto_stop_word => QueryAutoStopWord,
      #:russian => Russian,
      :simple => Simple, # no version?
      #:smart_chinese => SmartChinese,
      #:snowball => Snowball,
      :standard => Standard, # TODO: stopwords file
      :stop => Stop, # TODO: StopAnalyzer(matchVersion, File stopwordsFile) 
      #:thai => Thai,
      :whitespace => Whitespace # no version?
    }

=begin rdoc
    module Standard
    end

    def analyze_document(doc, analyzer=:whitespace)
      analyzer = org.apache.lucene.analysis.standard.StandardAnalyzer.new(org.apache.lucene.util.Version::LUCENE_30)
    end
=end

=begin rdoc
Custom analyzer:
 Analyzer ana = CustomAnalyzer.builder(Paths.get("/path/to/config/dir"))
   .withTokenizer("standard")
   .addTokenFilter("standard")
   .addTokenFilter("lowercase")
   .addTokenFilter("stop", "ignoreCase", "false", "words", "stopwords.txt", "format", "wordset")
   .build();
=end

  end
end
