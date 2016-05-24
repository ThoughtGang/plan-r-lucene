#!/usr/bin/env ruby
# (c) Copyright 2016 Thoughtgang <http://www.thoughtgang.org>
# Unit tests for PlanR Tika Plugin

require 'test/unit'

require 'plan-r/application'
require 'plan-r/application/jruby'
require 'plan-r/application/plugin_mgr'


class TC_TikaTest < Test::Unit::TestCase

  def test_1_startup
    PlanR::Application::Service.enable(PlanR::Application::ConfigManager)
    PlanR::Application::Service.enable(PlanR::Application::PluginManager)
    PlanR::Application::Service.enable('PlanR::Application::JRuby')
    PlanR::Application::Service.init_services
    PlanR::Application::Service.startup_services(self)
    assert_equal(true, PlanR::Application::JRuby.running?)
  end

  def test_2_connect
    obj = PlanR::Application::JRuby.connect
    assert_equal(DRb::DRbObject, obj.class)
    h = obj.send(:tika_parse_contents, { :contents => "<html></html>\n" })
    assert_equal('', h[:content])
    assert_equal('text/html; charset=ISO-8859-1', h[:metadata][:content_type])
    assert_equal('ISO-8859-1', h[:metadata][:content_encoding])
    # TODO: more sophisticated testing
    PlanR::Application::JRuby.disconnect
  end

  def test_9_9_9_shutdown
    PlanR::Application::Service.shutdown_services(self)
  end
end

