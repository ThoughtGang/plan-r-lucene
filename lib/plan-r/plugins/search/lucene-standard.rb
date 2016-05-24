#!/usr/bin/env ruby
# :title: PlanR::Plugins::LuceneStandard
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

        class LuceneStandard
          extend TG::Plugin
          name 'Lucene (Standard)'
          author 'dev@thoughtgang.org'
          version '1.0'
          description 'Standard lowercase, English analyser for Lucene'
          help 'Filters StandardTokenizer with StandardFilter, LowerCaseFilter and StopFilter, using a list of English stop words.
Note: Requires JRuby.'

          ANALYZER = :standard
          ANALYZER_ARGS = []
          def tokenize(doc, h)
            toks = Index::lucene_tokenize(doc.plaintext, ANALYZER, 
                                          ANALYZER_ARGS)
            PlanR::TokenStream.from_array(name, doc, (toks || []))
          end
          spec :tokenize_doc, :tokenize, 80 do |doc, h|
            next 0 if (! PlanR::Application::JRuby.running?)
            80
          end

=begin rdoc
=end
# create document [fields: id, title, body]
# add document -> per analyzer
# Note: tokens are discarded
          def index_document(repo, doc, h_tok)
            # create searchable text from tokens. this is needed because
            # lucene calls the tokenizer *anyways*.
            # NOTE: parsed_doc is in toks.doc
            toks = h_tok[name]
            text = toks.join(' ')
            # TODO: use parsed_doc.plaintext if toks.empty?
            #       or use toks.join if ! toks.doc?
            #       which is better?

            Index::lucene_index(index_path(repo), doc.path, text, 
                                doc.properties.to_h, ANALYZER, ANALYZER_ARGS)
          end
          spec :index_doc, :index_document, 50 do |r, doc, h|
            50
          end

          def query(repo, query)
            Index::lucene_query(index_path(repo), query,
                                ANALYZER, ANALYZER_ARGS)
          end
          spec :query_index, :query, 50 do |r,q|
            50
          end

          def related_documents(doc)
            Index::lucene_related_docs(index_path(doc.repo), doc)
          end
          spec :related_docs, :related_documents, 50 do |d|
            50
          end

          def keywords(repo, h={})
            Index::lucene_keywords(index_path(repo), h)
          end
          spec :index_keywords, :keywords, 50 do |r, h|
            50
          end

          def index_path(repo)
            File.join(repo.base_path, ::Lucene::Index::BASE, 'std.index')
          end

          PlanR::Application::PluginManager.blacklist(canon_name) if ! \
                                              PlanR::Application::JRuby.running?
        end

      end

    end
  end
end
