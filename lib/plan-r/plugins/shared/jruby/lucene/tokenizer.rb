#!/usr/bin/env jruby
# :title: PlanR::Plugins::Shared::Lucene::Tokenizer
=begin rdoc
(c) Copyright 2016 Thoughtgang <http://www.thoughtgang.org>
NOTE: This module should only be loaded in a JRuby process.
=end

require 'plan-r/plugins/shared/jruby/lucene/core'

# =============================================================================
module Lucene

=begin rdoc
Lucene Tokenizer module. This provides a namespace for the various Lucene 
tokenizers.
=end
  module Tokenizer
    # org.apache.lucene.analysis.standard.StandardTokenizer
    # org.apache.lucene.analysis.standard.ClassicFilter
    # org.apache.lucene.analysis.standard.StandardFilter
    # org.apache.lucene.analysis.standard.ClassicTokenizer
    # org.apache.lucene.analysis.standard.StandardTokenizer
    # org.apache.lucene.analysis.core.WhitespaceTokenizer
    # org.apache.lucene.analysis.core.DecimalDigitFilterFactory 
    # org.apache.lucene.analysis.core.LowerCaseFilterFactory 
    # org.apache.lucene.analysis.core.StopFilterFactory 
    # org.apache.lucene.analysis.core.TypeTokenFilterFactory 
    # org.apache.lucene.analysis.core.UpperCaseFilterFactory 
    # org.apache.lucene.analysis.core.KeywordTokenizerFactory
    # org.apache.lucene.analysis.core.LetterTokenizerFactory
    # org.apache.lucene.analysis.core.LowerCaseTokenizerFactory
    # org.apache.lucene.analysis.core.WhitespaceTokenizerFactory
    # org.apache.lucene.analysis.core.DecimalDigitFilter
    # org.apache.lucene.analysis.core.StopFilter
    # org.apache.lucene.analysis.core.TypeTokenFilter
    # org.apache.lucene.analysis.core.LowerCaseFilter
    # org.apache.lucene.analysis.core.Lucene43StopFilter
    # org.apache.lucene.analysis.core.Lucene43TypeTokenFilter
    # org.apache.lucene.analysis.core.UpperCaseFilter
    # org.apache.lucene.analysis.core.LetterTokenizer
    # org.apache.lucene.analysis.core.LowerCaseTokenizer
    # org.apache.lucene.analysis.core.UnicodeWhitespaceTokenizer
    # org.apache.lucene.analysis.core.WhitespaceTokenizer
    # org.apache.lucene.analysis.core.KeywordTokenizer
    # org.apache.lucene.analysis.synonym.SynonymFilter
    # org.apache.lucene.analysis.synonym.SynonymFilterFactory
    # org.apache.lucene.analysis.pattern.PatternTokenizer
    # org.apache.lucene.analysis.path.PathHierarchyTokenizer
    # org.apache.lucene.analysis.ngram.NGramTokenizer
    # org.apache.lucene.analysis.hunspell.HunspellStemFilter
    # org.apache.lucene.analysis.commongrams.CommonGramsFilter
    # org.apache.lucene.analysis.commongrams.CommonGramsQueryFilter
    # org.apache.lucene.analysis.charfilter.HTMLStripCharFilter
    # org.apache.lucene.analysis.standard.StandardTokenizer
    # org.apache.lucene.analysis.standard.StandardFilter
    # org.apache.lucene.analysis.core.LowerCaseFilter
    # org.apache.lucene.analysis.core.StopFilter
    #

# 

# 
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
    #QueryAutoStopWord=org.apache.lucene.analysis.query.QueryAutoStopWordAnalyzer
    #Russian = org.apache.lucene.analysis.ru.RussianAnalyzer
    Simple = org.apache.lucene.analysis.SimpleAnalyzer
    #SmartChinese = org.apache.lucene.analysis.cn.smart.SmartChineseAnalyzer
    #Snowball = org.apache.lucene.analysis.snowball.SnowballAnalyzer
    Standard = org.apache.lucene.analysis.standard.StandardAnalyzer
    Stop = org.apache.lucene.analysis.StopAnalyzer
    #Thai = org.apache.lucene.analysis.th.ThaiAnalyzer
    Whitespace = org.apache.lucene.analysis.WhitespaceAnalyzer

    TOKENIZERS = {
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

    NO_VERSION_CTOR = [
      :keyword
    ]

    module Attributes
      include_package 'org.apache.lucene.analysis.tokenattributes'
    end

    # TODO: this can probably be handled better
    def self.tokenizer_args(tokenizer, caller_args)
      args = []
      args << Lucene::Version::LUCENE_CURRENT unless \
              NO_VERSION_CTOR.include? tokenizer
      args.concat caller_args
    end

    def self.instantiate_tokenizer(tokenizer, tok_args)
      args = tokenizer_args(tokenizer, tok_args)
      (TOKENIZERS[tokenizer] || Standard).new( *args )
    end

=begin rdoc
Return an Array of tokens for document.
=end
    def self.tokenize_document(text, tokenizer=:standard, tok_args=[])
      obj = instantiate_tokenizer(tokenizer, tok_args)

      # NOTE: need to index different fields for different analyzers?
      stream = obj.tokenStream( "body", java.io.StringReader.new(text) )
      attr = stream.addAttribute Attributes::CharTermAttribute.java_class

      toks = []
      while stream.incrementToken() do
        toks << attr.to_s
      end

      toks
    end

  end
end
