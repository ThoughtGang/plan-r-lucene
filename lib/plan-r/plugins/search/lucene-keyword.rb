#!/usr/bin/env ruby
# :title: PlanR::Plugins::LuceneKeyword
=begin rdoc
=Lucene Plugins
(c) Copyright 2016 Thoughtgang <http://www.thoughtgang.org>

Note: These plugins are called from a standard Ruby process, and communicate
      with a JRuby process via DRb.
=end

require 'plan-r/plugin'
require 'plan-r/application/jruby'
require 'plan-r/plugins/shared/lucene/index'
require 'plan-r/plugins/shared/lucene/server'
require 'plan-r/plugins/shared/lucene/settings'

module PlanR
  module Plugins
    module Lucene

      module Index

        class LuceneKeyword
          extend TG::Plugin
          name 'Lucene (Keyword)'
          author 'dev@thoughtgang.org'
          version '1.0'
          description 'Single-token (i.e. no-op) analyzer for Lucene.'
          help '"Tokenizes" the entire stream as a single token. This is useful for data like zip codes, ids, and some product names.
Note: Requires JRuby.'

          ANALYZER = :keyword
          ANALYZER_ARGS = [] # TODO: list of keywords?
          def tokenize(doc, h)
            # TODO: user-supplied keywords?
            toks = Index::lucene_tokenize(doc.plaintext, ANALYZER, ANALYZER_ARGS)
            PlanR::TokenStream.from_array(name, doc, (toks || []))
          end
          spec :tokenize_doc, :tokenize, 10 do |doc, h|
            10
          end

          def index_document(repo, doc, h_tok)
            toks = h_tok[name]
            text = toks.join(' ')
            Index::lucene_index(index_path(repo), doc.path, text, 
                                doc.properties.to_h, ANALYZER, ANALYZER_ARGS)
          end
          spec :index_doc, :index_document, 50 do |r, doc, h|
            50
          end

          def related_documents(doc)
            Index::lucene_related_docs(index_path(doc.repo), doc)
          end
          spec :related_docs, :related_documents, 50 do |q|
            50
          end

          def keywords(repo, h={})
            Index::lucene_keywords(index_path(repo), h)
          end
          spec :index_keywords, :keywords, 50 do |r,h|
            50
          end

          def index_path(repo)
            File.join(repo.base_path, ::Lucene::Index::BASE, 'ws.index')
          end

          PlanR::Application::PluginManager.blacklist(canon_name) if ! \
                                              PlanR::Application::JRuby.running?
        end

      end

    end
  end
end
