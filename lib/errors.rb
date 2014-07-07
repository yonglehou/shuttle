# Copyright 2014 Square Inc.
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

# Abstract error which should be subclassed for different object types, and
# subclass should be raised when a sha is no longer found in the Git repository.
#   @param [String] sha The error object.
#   @param [String] object_type The type of git object that is not found.
#   @param [String] msg The error message to record. If not provided, a default message
#                   will be created with the sha and object type.
class Git::NotFoundError < StandardError
  def initialize(sha, object_type = "Object", msg = nil)
    super(msg || "#{object_type} not found in git repo: #{sha} (it may have been rebased away)")
  end
end

# Raised when a {Commit}'s revision is no longer found in the Git repository.
#   @param [String] sha The error object.
#   @param [String] msg The error message to record. If not provided, a default message
#                   will be created with the sha and object type.
class Git::CommitNotFoundError < Git::NotFoundError
  def initialize(sha, msg = nil)
    super(sha, "Commit", msg)
  end
end

# Raised when a {Blob}'s sha is no longer found in the Git repository.
#   @param [String] sha The error object.
#   @param [String] msg The error message to record. If not provided, a default message
#                   will be created with the sha and object type.
class Git::BlobNotFoundError < Git::NotFoundError
  def initialize(sha, msg = nil)
    super(sha, "Blob", msg)
  end
end
