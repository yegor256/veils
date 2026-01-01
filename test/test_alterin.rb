# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2020-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'json'
require_relative '../lib/alterin'

# AlterIn test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2020-2026 Yegor Bugayenko
# License:: MIT
class AlterInTest < Minitest::Test
  def test_simple
    obj = Object.new
    def obj.plus(first, second)
      first + second
    end
    foo = AlterIn.new(obj, plus: proc { |a, b| [a + 1, b + 1] })
    assert_equal(7, foo.plus(2, 3))
  end

  def test_respond_to
    foo = AlterIn.new(Object.new)
    refute_respond_to(foo, :undefine_method)

    foo = AlterIn.new(Object.new, method_return_object: Object.new)
    assert_respond_to(foo, :method_return_object)

    foo = AlterIn.new(Object.new, method_return_false: false)
    assert_respond_to(foo, :method_return_false)

    foo = AlterIn.new(Object.new, method_return_nil: nil)
    assert_respond_to(foo, :method_return_nil)
  end
end
