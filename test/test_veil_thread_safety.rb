# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2020-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../lib/veil'

# Test asserts the strict thread-safe serializable order. Because the
# implementation lacks proper synchronization (e.g. a Mutex) around
# @pierced and method caching, this test will fail, proving that
# thread safety is broken.
class VeilThreadSafetyTest < Minitest::Test
  # Fake Methods Hash that sleeps when checking keys.
  class SlowMethods
    def initialize(methods)
      @methods = methods
    end

    def key?(key)
      sleep(0.2) if key == :cached
      @methods.key?(key)
    end

    def [](key)
      @methods[key]
    end
  end

  # Fake Origin that records event sequence.
  class TrackedOrigin
    attr_reader :events

    def initialize
      @events = []
    end

    def uncached
      @events << :uncached_called
    end
    
    def respond_to?(method, include_private = false)
      true
    end
  end

  def test_proves_thread_safety_is_broken
    origin = TrackedOrigin.new
    methods = SlowMethods.new({ cached: 'from_cache' })
    veil = Veil.new(origin, methods)

    t1 = Thread.new do
      veil.cached
      origin.events << :cached_returned
    end

    sleep(0.1)

    t2 = Thread.new do
      veil.uncached
    end

    t2.join
    t1.join

    # The lack of a Mutex allows t2 to pierce the veil while t1 is reading.
    # If a Mutex were present, t2 would block until t1 finishes.
    # Thus, this order EXPECTS the synchronized, thread-safe condition to occur,
    # proving that thread safety is broken since it currently fails,
    # registering [:uncached_called, :cached_returned] instead.
    assert_equal(
      [:cached_returned, :uncached_called],
      origin.events,
      'Thread safety is broken: concurrent piercing bypassed the reading thread'
    )
  end
end
