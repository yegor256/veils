# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2020-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../lib/veil'

# Test asserts the strict thread-safe serializable order. Because the
# implementation utilizes a Mutex around @pierced and method caching,
# this test ensures that a piercer thread doesn't bypass a reading thread.
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

  def test_thread_safety
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

    # The Mutex ensures t2 blocks until t1 finishes its reading operation.
    # Thus, this asserts the synchronized, thread-safe condition occurs,
    # registering [:cached_returned, :uncached_called] instead of failing.
    assert_equal(
      %i[cached_returned uncached_called],
      origin.events,
      'Thread safety should be maintained by the Mutex'
    )
  end
end
