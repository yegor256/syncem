# frozen_string_literal: true

# (The MIT License)
#
# SPDX-FileCopyrightText: Copyright (c) 2018-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

# SyncEm is a simple decorator of an existing object that makes all its
# methods thread-safe.
#
# For more information read
# {README}[https://github.com/yegor256/syncem/blob/master/README.md] file.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2025 Yegor Bugayenko
# License:: MIT
class SyncEm
  undef_method :send

  def initialize(origin)
    @origin = origin
    @mutex = Mutex.new
  end

  def method_missing(*args)
    @mutex.synchronize do
      mtd = args.shift
      if @origin.respond_to?(mtd)
        params = @origin.method(mtd).parameters
        reqs = params.count { |p| p[0] == :req }
        if params.any? { |p| p[0] == :key } && args.size > reqs
          @origin.__send__(mtd, *args[0...-1], **args.last) do |*a|
            yield(*a) if block_given?
          end
        else
          @origin.__send__(mtd, *args) do |*a|
            yield(*a) if block_given?
          end
        end
      else
        super
      end
    end
  end

  def respond_to?(method, include_private = false)
    @origin.respond_to?(method, include_private)
  end

  def respond_to_missing?(_method, _include_private = false)
    true
  end
end
