# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'threads'
require_relative '../lib/syncem'

# Syncem test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2025 Yegor Bugayenko
# License:: MIT
class SyncEmTest < Minitest::Test
  class Account
    def initialize(file)
      @file = file
    end

    def balance
      File.exist?(@file) ? File.read(@file).to_i : 0
    end

    def add(amount)
      now = File.exist?(@file) ? File.read(@file).to_i : 0
      File.write(@file, (now + amount).to_s)
    end

    def read
      yield balance
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
      assert_respond_to(acc, :balance)
      assert_respond_to(acc, :add)
    end
  end

  def test_works_with_send_method
    obj = Object.new
    def obj.send(_first, second)
      second
    end
    synced = SyncEm.new(obj)
    assert_equal(3, synced.send(2, 3))
    assert_equal({ y: 2 }, synced.send({ x: 1 }, { y: 2 }))
  end

  def test_works_with_optional_arguments
    obj = Object.new
    def obj.foo(first, _second, ext1: 'a', ext2: 'b')
      first + ext1 + ext2
    end
    synced = SyncEm.new(obj)
    assert_equal('.xy', synced.foo('.', {}, ext1: 'x', ext2: 'y'))
    assert_equal('fzb', synced.foo('f', {}, ext1: 'z'))
    assert_equal('-ab', synced.foo('-', {}))
  end

  def test_works_with_splat_arguments
    obj = Object.new
    def obj.foo(one, two, *rest)
      one + two + (rest.empty? ? '' : rest.first.to_s)
    end
    synced = SyncEm.new(obj)
    assert_equal('ab', synced.foo('a', 'b'))
    assert_equal('abc', synced.foo('a', 'b', 'c'))
  end

  def test_works_with_default_value
    obj = Object.new
    def obj.foo(first, second = 42)
      first + second
    end
    synced = SyncEm.new(obj)
    assert_equal(15, synced.foo(7, 8))
    assert_equal(43, synced.foo(1))
  end

  def test_works_with_block
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'f.txt')
      acc = SyncEm.new(Account.new(path))
      acc.add(50)
      before = 0
      acc.read do |b|
        assert_equal(50, b)
        before = b
      end
      assert_equal(50, before)
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
