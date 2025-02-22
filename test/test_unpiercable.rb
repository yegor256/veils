# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2020-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'json'
require_relative '../lib/unpiercable'

# Veil test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2020-2025 Yegor Bugayenko
# License:: MIT
class UnpiercableTest < Minitest::Test
  def test_simple
    obj = Object.new
    def obj.read(foo)
      foo
    end

    def obj.touch; end
    foo = Unpiercable.new(obj, read: 1)
    assert_equal(1, foo.read(5))
    foo.to_s
    foo.touch
    assert_equal(1, foo.read(5))
  end

  def test_behaves_like_array_with_json
    origin = [1, 2, 3]
    foo = Unpiercable.new(origin)
    assert(foo.respond_to?(:to_json))
    assert_equal(JSON.pretty_generate(origin), JSON.pretty_generate(foo))
  end

  def test_iterates_array
    origin = [1, 2, 3]
    foo = Unpiercable.new(origin, count: 1)
    assert_equal(1, foo.count)
    assert(!foo.empty?)
    assert_equal(1, foo.count)
    observed = 0
    foo.each { |_| observed += 1 }
    assert_equal(3, observed)
  end

  def test_iterates_array_twice
    origin = [1, 2, 3]
    foo = Veil.new(origin, count: 1)
    assert_equal(1, foo.count)
    observed = 0
    foo.each { |_| observed += 1 }
    assert_equal(3, observed)
  end

  def test_respond_to
    foo = Unpiercable.new(Object.new)
    assert_equal(false, foo.respond_to?(:undefine_method))

    foo = Unpiercable.new(Object.new, method_return_object: Object.new)
    assert_equal(true, foo.respond_to?(:method_return_object))

    foo = Unpiercable.new(Object.new, method_return_false: false)
    assert_equal(true, foo.respond_to?(:method_return_false))

    foo = Unpiercable.new(Object.new, method_return_nil: nil)
    assert_equal(true, foo.respond_to?(:method_return_nil))
  end
end
