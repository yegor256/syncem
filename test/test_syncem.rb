# frozen_string_literal: true

# (The MIT License)
#
# Copyright (c) 2018-2019 Yegor Bugayenko
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

require 'minitest/autorun'
require 'threads'
require_relative '../lib/syncem'

# Syncem test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2019 Yegor Bugayenko
# License:: MIT
class SyncEmTest < Minitest::Test
  class Account
    def initialize(file)
      @file = file
    end

    def balance
      File.exist?(@file) ? IO.read(@file).to_i : 0
    end

    def add(amount)
      now = File.exist?(@file) ? IO.read(@file).to_i : 0
      IO.write(@file, (now + amount).to_s)
    end
  end

  def test_wraps_simple_object
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'f.txt')
      acc = Account.new(path)
      assert_equal(0, acc.balance)
      acc.add(50)
      assert_equal(50, acc.balance)
      acc.add(-10)
      assert_equal(40, acc.balance)
    end
  end

  def test_respond_to
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'f.txt')
      acc = SyncEm.new(Account.new(path))
      assert(acc.respond_to?(:balance))
      assert(acc.respond_to?(:add))
    end
  end

  def test_multiple_threads
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'f.txt')
      acc = SyncEm.new(Account.new(path))
      threads = 10
      Threads.new(threads).assert do
        acc.add(10)
      end
      assert_equal(threads * 10, acc.balance)
    end
  end
end