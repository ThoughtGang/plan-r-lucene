#!/usr/bin/env ruby
# :title: PlanR::Plugins::Lucene
=begin rdoc
=Lucene Plugins
(c) Copyright 2016 Thoughtgang <http://www.thoughtgang.org>

Note: These plugins are called from a standard Ruby process, and communicate
      with a JRuby process via DRb.
=end

require 'drb'
require 'thread'

require 'plan-r/application/jruby'
require 'plan-r/plugins/shared/lucene/settings'

# TODO: Per-Analyzer plugins defining :tokenize :analyze :index :query.
#       This is more in line with how Lucene works. Analyzers are basically
#       TokenFilters applied to TokenStreams.
#       Ability to generate tokenizer in jruby from lucene tokenizers +
#       filters.

# TODO: Better classes. One plugin per token/analyze/index/query combo.
#       - Parser : Tika
#       - Search : Whitespace (tokenize, analyze, index, etc)
#       - Search : Standard (tokenize, analyze, index, etc)
# http://lucene.apache.org/java/3_0_2/api/all/org/apache/lucene/analysis/Analyzer.html

module PlanR
  module Plugins
    module Lucene


=begin
    # ========================================================================
    # TOKENIZER

    module Tokenize
# BROKEN TOKENIZERS - lucene-core no longer ships with these?
      class Arabic
        extend TG::Plugin
        name 'Lucene Arabic Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help 'This analyzer implements light-stemming as specified by: Light Stemming for Arabic Information Retrieval http://www.mtholyoke.edu/~lballest/Pubs/arab_stem05.pdf'

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :arabic)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class Brazilian
        extend TG::Plugin
        name 'Lucene Brazilian Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help ' Analyzer for Brazilian Portuguese language. Supports an external list of stopwords (words that will not be indexed at all) and an external list of exclusions (words that will not be stemmed, but indexed). '

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :brazilian)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class Chinese
        extend TG::Plugin
        name 'Lucene Chinese Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help ' An Analyzer that tokenizes text with ChineseTokenizer and filters with ChineseFilter'

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :chinese)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class CJK
        extend TG::Plugin
        name 'Lucene CJK Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help 'An Analyzer that tokenizes text with CJKTokenizer and filters with StopFilter'

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :cjk)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class Czech
        extend TG::Plugin
        name 'Lucene Czech Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help ''

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :czech)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class Dutch
        extend TG::Plugin
        name 'Lucene Dutch Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help ''

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :dutch)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class French
        extend TG::Plugin
        name 'Lucene French Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help ''

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :french)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class German
        extend TG::Plugin
        name 'Lucene German Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help ''

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :german)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class Greek
        extend TG::Plugin
        name 'Lucene Greek Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help ''

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :greek)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class IcuCollation
        extend TG::Plugin
        name 'Lucene IcuCollation Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help ' Filters KeywordTokenizer with ICUCollationKeyFilter. Converts the token into its CollationKey, and then encodes the CollationKey with IndexableBinaryStringTools, to allow it to be stored as an index term. '

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :icu_collation)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class Pattern
        extend TG::Plugin
        name 'Lucene Pattern Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help 'Efficient Lucene analyzer/tokenizer that preferably operates on a String rather than a Reader, that can flexibly separate text into terms via a regular expression Pattern (with behaviour identical to String.split(String)), and that combines the functionality of LetterTokenizer, LowerCaseTokenizer, WhitespaceTokenizer, StopFilter into a single efficient multi-purpose class. '

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :pattern)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class Persian
        extend TG::Plugin
        name 'Lucene Persian Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help ''

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :persian)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class QueryAutoStopWord
        extend TG::Plugin
        name 'Lucene QueryAutoStopWord Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help 'An Analyzer used primarily at query time to wrap another analyzer and provide a layer of protection which prevents very common words from being passed into queries.'

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :query_auto_stop_word)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class Russian
        extend TG::Plugin
        name 'Lucene Russian Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help ''

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :russian)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class SmartChinese
        extend TG::Plugin
        name 'Lucene SmartChinese Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help ' SmartChineseAnalyzer is an analyzer for Chinese or mixed Chinese-English text. The analyzer uses probabilistic knowledge to find the optimal word segmentation for Simplified Chinese text. The text is first broken into sentences, then each sentence is segmented into words. Segmentation is based upon the Hidden Markov Model. A large training corpus was used to calculate Chinese word frequency probability. '

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :smart_chinese)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class Snowball
        extend TG::Plugin
        name 'Lucene Snowball Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help 'Filters StandardTokenizer with StandardFilter, LowerCaseFilter, StopFilter and SnowballFilter. Available stemmers are listed in org.tartarus.snowball.ext. The name of a stemmer is the part of the class name before "Stemmer", e.g., the stemmer in EnglishStemmer is named "English".'

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :snowball)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class Thai
        extend TG::Plugin
        name 'Lucene Thai Tokenizer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description ''
        help 'Analyzer for Thai language. It uses BreakIterator to break words.'

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, :thai)
          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 0 do |doc, h|
          0
        end
      end

      class Collation
        extend TG::Plugin
        name 'Lucene Collation Analyzer'
        author 'dev@thoughtgang.org'
        version '1.0-alpha'
        description 'Collation analyzer (IndexableBinaryString) for Lucene'
        help 'Filters KeywordTokenizer with CollationKeyFilter. Converts the token into its CollationKey, and then encodes the CollationKey with IndexableBinaryStringTools, to allow it to be stored as an index term. '

        def tokenize(doc, h)
          tokens = Lucene::Server.invoke(:tokenize_document, doc.plaintext, 
                                         :collation)

          t_doc = PlanR::TokenStream.from_array(name, doc, tokens)
        end
        spec :tokenize_doc, :tokenize, 10 do |doc, h|
          10
        end
      end

=end
    end
  end
end
