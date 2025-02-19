# frozen_string_literal: true

# (The MIT License)
#
# SPDX-FileCopyrightText: Copyright (c) 2020-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'json'
require_relative '../lib/alterout'

# AlterOut test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2020-2025 Yegor Bugayenko
# License:: MIT
class AlterOutTest < Minitest::Test
  def test_simple
    obj = Object.new
    def obj.read(val)
      val
    end
    foo = AlterOut.new(obj, read: proc { |r| r + 1 })
    assert_equal(6, foo.read(5))
  end

  def test_respond_to
    foo = AlterOut.new(Object.new)
    assert_equal(false, foo.respond_to?(:undefine_method))

    foo = AlterOut.new(Object.new, method_return_object: Object.new)
    assert_equal(true, foo.respond_to?(:method_return_object))

    foo = AlterOut.new(Object.new, method_return_false: false)
    assert_equal(true, foo.respond_to?(:method_return_false))

    foo = AlterOut.new(Object.new, method_return_nil: nil)
    assert_equal(true, foo.respond_to?(:method_return_nil))
  end
end
