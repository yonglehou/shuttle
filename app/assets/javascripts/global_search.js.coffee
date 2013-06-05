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

root = exports ? this

# This object manages the search results of the global search page.

class root.GlobalSearch

  # Creates a new search results manager.
  #
  # @param [jQuery element] element A `TABLE` element to store search results
  #   in.
  # @param [String] url A URL to fetch search results from.

  constructor: (@element, @url) ->
    this.setupTable()

  # Clears the table and fetches new search results.
  #
  # @param [String] params Query parameters to include with the URL.

  refresh: (params) ->
    $.ajax @url,
      type: 'POST'
      data: params
      success: (translations) =>
        this.setMessage()
        if translations.length == 0
          this.setMessage "No translations found."
        else
          for translation in translations
            do (translation) => this.addTranslation(translation)
      error: => this.setMessage("Couldn’t load translations")

  # Appends a translation to the results list.
  #
  # @param [Object] translation Translation information.

  addTranslation: (translation) ->
    tr = $('<tr/>').appendTo(@body)
    $('<td/>').text(translation.project.name).appendTo tr
    id = $('<td/>').appendTo tr
    $('<a/>').text(translation.id).attr('href', translation.url).appendTo(id)
    $('<td/>').text(translation.source_locale.name).appendTo tr
    $('<td/>').text(translation.source_copy).appendTo tr
    $('<td/>').text(translation.locale.name).appendTo tr
    if translation.translated
      class_name = if translation.approved == true
          'text-success'
        else if translation.approved == false
          'text-error'
        else
          'text-info'
      $('<td/>').addClass(class_name).text(translation.copy).appendTo tr
    else
      $('<td/>').addClass('muted').text("(untranslated)").appendTo tr

  # Sets or clears a table-wide informational message. Removes all rows from the
  # table.
  #
  # @param [String, null] A message to display, or `null` to clear the message.

  setMessage: (message=null) ->
    @body.empty()
    if message?
      tr = $('<tr/>').appendTo(@body)
      $('<td/>').attr('colspan', 6).addClass('loading').text(message).appendTo tr

  # @private
  setupTable: ->
    @element.empty()
    thead = $('<thead/>').appendTo(@element)
    tr = $('<tr/>').appendTo(thead)

    $('<th/>').text("Project").appendTo tr
    $('<th/>').text("ID").appendTo tr
    $('<th/>').text("From Locale").appendTo tr
    $('<th/>').text("From Copy").appendTo tr
    $('<th/>').text("To Locale").appendTo tr
    $('<th/>').text("To Copy").appendTo tr

    @body = $('<tbody/>').appendTo(@element)
