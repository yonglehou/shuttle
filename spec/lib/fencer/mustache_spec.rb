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

describe Fencer::Mustache do
  describe ".fence" do
    it "should fence a string with handlebars" do
      Fencer::Mustache.fence("String with {{two}} {{tokens}}.").
          should eql('{{two}}' => [12..18], '{{tokens}}' => [20..29])
    end

    it "should fence a string with triple handlebars" do
      Fencer::Mustache.fence("String with {{{two}}} {{{tokens}}}.").
          should eql('{{{two}}}' => [12..20], '{{{tokens}}}' => [22..33])
    end

    it "should fence special tokens" do
      Fencer::Mustache.fence("String with {{#opening}} and {{/closing}} token.").
          should eql('{{#opening}}' => [12..23], '{{/closing}}' => [29..40])
    end
  end
end
