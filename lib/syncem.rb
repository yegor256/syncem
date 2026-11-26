# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2019 Yegor Bugayenko
# SPDX-License-Identifier: MIT

# SyncEm is a simple decorator of an existing object that makes all its
# methods thread-safe.
#
# For more information read
# {README}[https://github.com/yegor256/syncem/blob/master/README.md] file.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2019 Yegor Bugayenko
# License:: MIT
class SyncEm
  undef_method :send

  def initialize(origin)
    @origin = origin
    @mutex = Mutex.new
  end

  def method_missing(mtd, *args)
    @mutex.synchronize do
      if @origin.respond_to?(mtd)
        @origin.__send__(mtd, *args) do |*a|
          yield(*a) if block_given?
        end
      else
        super
      end
    end
  end
  ruby2_keywords(:method_missing) if respond_to?(:ruby2_keywords, true)

  def respond_to?(method, include_private = false)
    @origin.respond_to?(method, include_private)
  end

  def respond_to_missing?(method, include_private = false)
    @origin.respond_to?(method, include_private) || super
  end
end
