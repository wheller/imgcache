module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      compile:
        files:
          'lib/imgcache.js': ['src/*.coffee']
    nodeunit:
      files: ['test/*.coffee'],
      options:
        reporter: 'default'
    jshint:
      files: ['lib/**/*.js']
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.registerTask 'default', ['coffee','nodeunit','jshint']
