# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2020-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'json'
require_relative '../lib/veil'

# Veil test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2020-2025 Yegor Bugayenko
# License:: MIT
class VeilTest < Minitest::Test
  def test_simple
    obj = Object.new
    def obj.read(foo)
      foo
    end

    def obj.touch; end
    foo = Veil.new(obj, read: 1)
    assert_equal(1, foo.read(5))
    foo.to_s
    foo.touch
    assert_equal(5, foo.read(5))
  end

  def test_behaves_like_array_with_json
    origin = [1, 2, 3]
    foo = Veil.new(origin)
    assert_respond_to(foo, :to_json)
    assert_equal(JSON.pretty_generate(origin), JSON.pretty_generate(foo))
  end

  def test_iterates_array
    origin = [1, 2, 3]
    foo = Veil.new(origin, count: 1)
    assert_equal(1, foo.count)
    refute_empty(foo)
    assert_equal(3, foo.count)
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
    foo = Veil.new(Object.new)
    refute_respond_to(foo, :undefine_method)

    foo = Veil.new(Object.new, method_return_object: Object.new)
    assert_respond_to(foo, :method_return_object)

    foo = Veil.new(Object.new, method_return_false: false)
    assert_respond_to(foo, :method_return_false)

    foo = Veil.new(Object.new, method_return_nil: nil)
    assert_respond_to(foo, :method_return_nil)
  end
end
