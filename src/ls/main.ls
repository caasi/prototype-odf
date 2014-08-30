React = require 'react'

{div, span, ul, li} = React.DOM
{cloneDeep}         = require 'lodash'

ODFNode = React.createClass do
  displayName: 'ODFNode'
  getDefaultProps: ->
    data: null
  render: ->
    {value, children} = @props.data
    div do
      className: 'tag'
      "#{value.prefix}:#{value.local}"
      ul do
        className: 'attributes'
        for let key, attr of value.attributes
          li do
            key: key
            className: 'attribute'
            span do
              className: 'key'
              "#{attr.prefix}:#{attr.local}"
            span do
              className: 'value'
              "#{attr.value}"
      ul do
        null
        for let i, child of children
          li do
            do
              key: i
            ODFNode data: child

###
# parse xml
$   = require 'jquery'
sax = require 'sax'

parser = sax.parser false, lowercase: on xmlns: on
counter = 0
root = null
stack = []

parser
  ..onopentag  = !(node) ->
    box = do
      value: node
      children: []
    if stack.length
      stack[* - 1]children.push box
    else
      root := box
    stack.push box
    counter++
  ..onclosetag = !-> stack.pop!
  ..onend      = !->
    $ '#dropzone' .hide!
    console.log root
    console.log "#counter nodes parsed"
    React.renderComponent do
      ODFNode data: root
      document.getElementById 'odf'
  ..onerror    = !(err) ->
    console.log err
    parser.error = null # will remove error and continue

###
# drag and drop files
drag-drop = require 'drag-drop/buffer'
zip       = require 'zip'
utils     = require './utils'

zip.workerScriptsPath = './js/'

drag-drop '#dropzone' (files) ->
  for file in files
    reader  <- zip.createReader new zip.TextReader file.buffer
    entries <- reader.getEntries
    console.log 'unzipped'
    for entry in entries
      if entry.filename in <[content.xml]> #<[styles.xml]>
        data <- entry.getData new zip.TextWriter 'text/plain'
        console.log 'parsing'
        parser
          .write data
          .close!
