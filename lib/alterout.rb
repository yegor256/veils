# frozen_string_literal: true

# (The MIT License)
#
# SPDX-FileCopyrightText: Copyright (c) 2020-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

# Decorator to modify method outputs.
#
# For more information read
# {README}[https://github.com/yegor256/veils/blob/master/README.md] file.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2020-2025 Yegor Bugayenko
# License:: MIT
class AlterOut
  def initialize(origin, methods = {})
    @origin = origin
    @methods = methods
  end

  def to_s
    method_missing(:to_s)
  end

  def to_json(options = nil)
    return @origin.to_a.to_json(options) if @origin.is_a?(Array)
    method_missing(:to_json, options)
  end

  def method_missing(*args)
    method = args[0]
    raise "Method #{method} is absent in #{@origin}" unless @origin.respond_to?(method)
    out =
      if block_given?
        @origin.__send__(*args) do |*a|
          yield(*a)
        end
      else
        @origin.__send__(*args)
      end
    out = @methods[method].call(out) if @methods.key?(method)
    out
  end

  def respond_to?(method, include_private = false)
    @origin.respond_to?(method, include_private) || @methods.key?(method)
  end

  def respond_to_missing?(_method, _include_private = false)
    true
  end
end
