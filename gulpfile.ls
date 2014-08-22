require! <[gulp gulp-concat gulp-filter gulp-flatten]>
connect    = require \gulp-connect
gutil      = require \gulp-util
livescript = require \gulp-livescript
stylus     = require \gulp-stylus
jade       = require \gulp-jade

path =
  src:   './src'
  build: '.'

gulp.task \css ->
  gulp.src [
    "#{path.src}/**/*.styl"
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

gulp.task \build <[css html]>

gulp.task \watch <[build]> ->
  gulp
    ..watch 'bower.json'             <[vendor]>
    #..watch "#{path.src}/**/*.ls"    <[js]>
    ..watch "#{path.src}/**/*.styl"  <[css]>
    ..watch "#{path.src}/*.jade"     <[html]>

gulp.task \server <[watch]> ->
  connect.server do
    root: path.build
    livereload: on

gulp.task \default <[server]>
