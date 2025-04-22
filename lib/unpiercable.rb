# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2020-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

# Unpiercable is a simple decorator of an existing object that works
# exactly like Veil, but can never be pierced.
#
# For more information read
# {README}[https://github.com/yegor256/veils/blob/master/README.md] file.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2020-2025 Yegor Bugayenko
# License:: MIT
class Unpiercable
  # Create a new unpiercable wrapper around an object.
  # Unlike Veil, this wrapper can never be pierced.
  #
  # @param origin [Object] The object to wrap
  # @param methods [Hash] A hash of method name to returned value mappings
  # @return [Unpiercable] The wrapped object
  def initialize(origin, methods = {})
    @origin = origin
    @methods = methods
  end

  # Returns a string representation of the object.
  # This method will use the defined value if available or delegate to the original object.
  #
  # @return [String] String representation
  def to_s
    method_missing(:to_s)
  end

  # Returns a JSON representation of the object.
  # Handles arrays specially by converting to array first.
  #
  # @param options [Object] JSON generation options
  # @return [String] JSON representation
  def to_json(options = nil)
    return @origin.to_a.to_json(options) if @origin.is_a?(Array)
    method_missing(:to_json, options)
  end

  def method_missing(*args)
    method = args[0]
    if @methods.key?(method)
      @methods[method]
    else
      raise "Method #{method} is absent in #{@origin}" unless @origin.respond_to?(method)
      if block_given?
        @origin.__send__(*args) do |*a|
          yield(*a)
        end
      else
        @origin.__send__(*args)
      end
    end
  end

  def respond_to?(method, include_private = false)
    @origin.respond_to?(method, include_private) || @methods.key?(method)
  end

  def respond_to_missing?(_method, _include_private = false)
    true
  end
end
