# frozen_string_literal: true

# (The MIT License)
#
# Copyright (c) 2020-2025 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
