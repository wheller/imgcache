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
      clean:
        command: 'rm -rf test/testcache'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-exec'
  grunt.registerTask 'clean', ['exec:clean']
  grunt.registerTask 'default', ['clean','coffee','nodeunit','jshint']
  grunt.registerTask 'build', ['coffee']
  grunt.registerTask 'test', ['clean','nodeunit','jshint']
  grunt.registerTask 'debug', ['clean','coffee','exec:debug']
