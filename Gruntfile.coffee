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
    exec:
      debug:
        command: 'node-debug --debug-brk $(which grunt) nodeunit'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-exec'
  grunt.registerTask 'default', ['coffee','nodeunit','jshint']
  grunt.registerTask 'build', ['coffee']
  grunt.registerTask 'test', ['nodeunit','jshint']
  grunt.registerTask 'debug', ['exec:debug']
