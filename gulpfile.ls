require! <[gulp gulp-concat]>
gutil      = require \gulp-util
webpack    = require \gulp-webpack
connect    = require \gulp-connect
livescript = require \gulp-livescript
stylus     = require \gulp-stylus
jade       = require \gulp-jade

path =
  src:   "#__dirname/src"
  dest:  "#__dirname/dest"
  build: __dirname

gulp.task \js ->
  gulp.src [
    "#{path.src}/ls/**/*.ls"
  ]
    .pipe livescript!
    .pipe gulp.dest "#{path.dest}/"

gulp.task \webpack <[js]> ->
  gulp
    .src "#{path.dest}/main.js"
    .pipe webpack do
      context: "#{path.dest}/"
      output:
        filename: 'build.js'
      externals:
        zip: 'zip'
    .pipe gulp.dest "#{path.build}/js"
    .pipe connect.reload!

gulp.task \css ->
  gulp.src [
    "#{path.src}/stylus/**/*.styl"
  ]
    .pipe gulp-concat 'style.styl'
    .pipe stylus use: <[nib]>
    .pipe gulp.dest "#{path.build}/css"
    .pipe connect.reload!

gulp.task \html ->
  gulp.src "#{path.src}/*.jade"
    .pipe jade!
    .pipe gulp.dest path.build
    .pipe connect.reload!

gulp.task \build <[webpack css html]>

gulp.task \watch <[build]> ->
  gulp
    ..watch "#{path.src}/ls/**/*.ls"    <[webpack]>
    ..watch "#{path.src}/stylus/**/*.styl"  <[css]>
    ..watch "#{path.src}/*.jade"     <[html]>

gulp.task \server <[watch]> ->
  connect.server do
    root: path.build
    livereload: on

gulp.task \default <[server]>
