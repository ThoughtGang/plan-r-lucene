#!/usr/bin/env ruby
# (c) Copyright 2016 Thoughtgang <http://www.thoughtgang.org>
# Unit tests for PlanR Lucene Plugin

require 'test/unit'

require 'plan-r/application'
require 'plan-r/application/jruby'
require 'plan-r/application/plugin_mgr'

require_relative "../shared/shm_repo"

DOCS = [
    { :path => 'a/1', :data => 'asm is as asm does' },
    { :path => 'a/2', :data => 'assembly language for stoners' },
    { :path => 'a/3', :data => 'learn assembler in a day' },
    { :path => 'a/4', :data => 'assembly and disassembly the hard way' },
    { :path => 'b/1', :data => 'work on an assembly-line factory' },
    { :path => 'b/2', :data => 'once twice three times assembly' },
    { :path => 'b/3', :data => 'assembly and disassembly of fnord falcon' },
    { :path => 'b/4', :data => 'picture an assembly of birds' },
    { :path => 'c.1', :data => 'machine language and the rest of us' },
    { :path => 'c.2', :data => 'where in the world is carmen assembler' },
    { :path => 'c.3', :data => 'the manual for demanualling' },
    { :path => 'c.4', :data => 'more nonsense' },
    { :path => 'z', :data => 'a few final words.' }
  ]

class TC_LuceneTest < Test::Unit::TestCase

  CONTENT_BASE = shm_repo('lucene-test')

  def test_1_create_repo
    PlanR::Application::Service.enable(PlanR::Application::ConfigManager)
    PlanR::Application::Service.enable(PlanR::Application::PluginManager)
    PlanR::Application::Service.enable('PlanR::Application::JRuby')

    PlanR::Application::Service.init_services
    PlanR::Application::Service.startup_services(self)
    assert_equal(true, PlanR::Application::JRuby.running?)

    $repo = PlanR::Repo.create('test-repo', CONTENT_BASE)
    assert_not_nil($repo, 'Repo not created')
    #path = File.join(CONTENT_BASE,
    #                 PlanR::Plugins::Search::PickyDomainIndex::NORMALIZER_FILE)
    #File.open(path, 'w') do |f|
    #  f.puts "assembly language\tasm"
    #  f.puts "assembler\tasm"
    #  f.puts "machine language\tasm"
    #  f.puts "machine code\tasm"
    #end
    #assert(File.exist? path)

    # manually invoke object_loaded since we didn't use RepoManager
    PlanR::Application::PluginManager.object_loaded(self, $repo)

    DOCS.each do |doc|
      $repo.add(doc[:path], doc[:data], :document)
      PlanR::Application::DocumentManager.import_raw($repo, doc[:path],
                                doc[:data], PlanR::Document.default_properties)
    end
  end

  def test_2_0_keywords_list
    idx = PlanR::Plugins::Lucene::Index::LuceneKeywordIndex.name
    h = PlanR::Application::QueryManager.index_keywords($repo, {}, idx)
    puts h.inspect
  end

  def test_3_0_search
    #idx = PlanR::Plugins::Lucene::Index::LuceneKeywordIndex.name
    #q = PlanR::Query.new('asm')
    #h_rv = PlanR::Application::QueryManager.perform($repo, q, idx)
    #puts h_rv.inspect
    #results = h_rv[idx]
    #docs = DOCS.inject([]) { |arr,h|
    #    arr << h[:path] if h[:tags].map { |ht| ht.downcase }.include? t
    #    arr
    #}.sort
    #assert_equal(docs, results.map { |r| r.path }.sort )
  end

  def test_9_9_9_shutdown
    PlanR::Application::Service.shutdown_services(self)
  end
end

FileUtils.remove_dir(CONTENT_BASE) if File.exist?(CONTENT_BASE)
