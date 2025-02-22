# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'English'
Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.required_ruby_version = '>=2.3'
  s.name = 'syncem'
  s.version = '0.0.0'
  s.license = 'MIT'
  s.summary = 'Thread-safe decorator of Ruby objects'
  s.description = 'Sometimes you have an object that is not thread-safe,
but you need to make sure each of its methods is thread-safe, because they
deal with some resources, like files or databases and you want them to
manage those resources sequentially. This small gem will help you achieve
exactly that without any re-design of the objects you already have. Just
decorate them with SyncEm decorator and that is it.'
  s.authors = ['Yegor Bugayenko']
  s.email = 'yegor256@gmail.com'
  s.homepage = 'http://github.com/yegor256/syncem'
  s.files = `git ls-files`.split($RS)
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = ['README.md']
  s.metadata['rubygems_mfa_required'] = 'true'
end
