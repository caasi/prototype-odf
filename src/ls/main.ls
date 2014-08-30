$         = require 'jquery'
drag-drop = require 'drag-drop/buffer'
zip       = require 'zip'
sax       = require 'sax'
utils     = require './utils'

# setup
zip.workerScriptsPath = './js/'
parser = sax.parser false, lowercase: on xmlns: on

counter = 0
parser
  ..onopentag = (node) ->
    node <<< utils.namespace node.name
    counter++
  ..onend     = ->
    console.log "#counter nodes parsed"
  ..onerror   = (err) ->
    console.log err
    # remove error and continue
    parser.error = null

drag-drop '#dropzone' (files) ->
  for file in files
    reader  <- zip.createReader new zip.TextReader file.buffer
    entries <- reader.getEntries
    console.log 'unzipped'
    for entry in entries
      if entry.filename in <[content.xml styles.xml]>
        data <- entry.getData new zip.TextWriter 'text/plain'
        console.log 'parsing'
        parser
          .write data
          .close!
