# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2020-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

# Veil is a simple decorator of an existing object that makes some of
# its methods cache all values and calculate them only once.
#
# For more information read
# {README}[https://github.com/yegor256/veils/blob/master/README.md] file.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2020-2025 Yegor Bugayenko
# License:: MIT
class Veil
  # Create a new veil around an object.
  #
  # @param origin [Object] The object to wrap
  # @param methods [Hash] A hash of method name to returned value mappings
  # @return [Veil] The wrapped object
  def initialize(origin, methods = {})
    @origin = origin
    @methods = methods
    @pierced = false
  end

  # Returns a string representation of the object.
  # This method will use the veil value if available or delegate to the original object.
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

  # Handles method calls that are not defined in this class.
  # Either returns the pre-defined value from the methods hash or delegates to the original object.
  # Once any method not in the methods hash is called, the veil is permanently pierced.
  #
  # @param args [Array] The method name and arguments
  # @return [Object] The result of the method call
  # @raise [RuntimeError] If the method doesn't exist on the original object
  def method_missing(*args)
    method = args[0]
    if @pierced || !@methods.key?(method)
      @pierced = true
      raise "Method #{method} is absent in #{@origin}" unless @origin.respond_to?(method)
      if block_given?
        @origin.__send__(*args) do |*a|
          yield(*a)
        end
      else
        @origin.__send__(*args)
      end
    else
      @methods[method]
    end
  end

  # Determines if the object responds to the given method.
  # Checks both the original object and the methods hash.
  #
  # @param method [Symbol] The method name to check
  # @param include_private [Boolean] Whether to include private methods
  # @return [Boolean] True if the method can be handled
  def respond_to?(method, include_private = false)
    @origin.respond_to?(method, include_private) || @methods.key?(method)
  end

  # Indicates that all missing methods can be handled.
  #
  # @param _method [Symbol] The method name (unused)
  # @param _include_private [Boolean] Whether to include private methods (unused)
  # @return [Boolean] Always returns true
  def respond_to_missing?(_method, _include_private = false)
    true
  end
end
