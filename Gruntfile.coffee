"use strict"




module.exports = (grunt, options) ->
  pkg = grunt.file.readJSON('package.json')
  require('load-grunt-tasks') grunt

  options =
    paths: null # UNIMPLEMENTED




  ###### PLUGIN CONFIGURATIONS ######
  grunt.initConfig
    options: options

    pkg: pkg

    # grunt-contrib-watch
    watch:
      js:
        files: ['src/**/*.litcoffee','src/**/*.coffee', '!src/index.litcoffee']
        tasks: ['build']


    clean:
      dist:
        ['dist/*']
      temp:
        ['src/index.litcoffee']

    coffee:
      coffee_to_js:
        expand: true
        flatten: false
        files:
          "dist/mooog.js": "src/index.litcoffee"


    docco:
      debug:
        src: ['src/index.litcoffee']
        options:
          output: 'docs/'
          css: 'docco.css'
          layout: 'linear'

    concat:
      options:
        separator: '\n'
      dist:
        src: ['src/Mooog-doc.litcoffee', 'src/MooogAudioNode.litcoffee',  'src/nodes/*.litcoffee', 'src/Mooog.litcoffee'],
        dest: 'src/index.litcoffee',


    coffeelint:
      app: ['src/**/*.litcoffee']
      options:
        max_line_length:
          "value": 100,
          "level": "error",
          "limitComments": true

    uglify: {
      mooog: {
        options:
          sourceMap: true
          sourceMapName: 'dist/mooog.min.js.map'
          mangle: false
        files: {
          'dist/mooog.min.js': ['dist/mooog.js']
        }
      }
    }

  ######### TASK DEFINITIONS #########


  # build, watch
  grunt.registerTask 'dev', [
    'build'
    'watch'
  ]
  # concat and lint
  grunt.registerTask 'build', [
    'coffeelint'
    'concat'
#     'clean:dist'
    'coffee'
    'clean:temp'
  ]
  # build, docs
  grunt.registerTask 'prod', [
    'concat'
    'docco'
    'clean:dist'
    'coffee'
    'clean:temp'
    'uglify'
  ]


  grunt.registerTask 'default', ['dev']
