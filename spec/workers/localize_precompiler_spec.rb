# Copyright 2013 Square Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

require 'spec_helper'

describe LocalizePrecompiler do
  before(:each) do
    @commit = FactoryGirl.create(:commit)
    FileUtils.rm_f(LocalizePrecompiler.new.path(@commit))
  end

  describe "#perform" do
    subject { LocalizePrecompiler.new }

    it "compiles a given commit and stores the files on disk" do
      key          = FactoryGirl.create(:key, project: @commit.project, source: '/a/b/c.xib')
      @commit.keys = [key]
      translation  = FactoryGirl.create(:translation, key: key, translated: true, approved: true)
      @commit.recalculate_ready!
      @commit.should be_ready
      path = subject.path(@commit)
      File.exists?(path).should be_false
      subject.perform(@commit.id)
      File.exists?(path).should be_true
      # TODO (zb) : actually extract the tarball returned here and check its contents like the ios exporter spec
    end

    context "if an exception is thrown" do
      it "does not write an empty file" do
        path = subject.path(@commit)
        File.any_instance.stub(:putc).and_raise(RuntimeError)
        File.exists?(path).should be_false
        expect { subject.perform(@commit.id) }.to raise_error(RuntimeError)
        File.exists?(path).should be_false
      end
    end

    it "removes the lock" do
      mutex = subject.class.__send__(:mutex, @commit.id)
      mutex.lock!

      expect { subject.perform(@commit.id) }.to change { mutex.locked? }.from(true).to(false)
    end
  end
end
