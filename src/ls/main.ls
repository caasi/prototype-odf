$         = require 'jquery'
drag-drop = require 'drag-drop/buffer'
zip       = require 'zip'
sax       = require 'sax'
utils     = require './utils'

# setup
zip.workerScriptsPath = '/js/'
parser = sax.parser true # strict

parser.onopentag = (node) ->
  console.log utils.namespace node.name

console.log zip
drag-drop '#dropzone' (files) ->
  for file in files
    reader  <- zip.createReader new zip.TextReader file.buffer
    entries <- reader.getEntries
    for entry in entries
      if entry.filename in <[content.xml styles.xml]>
        data <- entry.getData new zip.TextWriter 'text/plain'
        parser
          .write data
          .close!
