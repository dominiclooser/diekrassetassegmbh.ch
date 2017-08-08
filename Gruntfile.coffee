time = require 'time-grunt'
jit = require 'jit-grunt'
autoprefixer = require 'autoprefixer'

config =
    exec: 
        'harp': 'harp compile'
    'gh-pages':
        production:
            options:
                base: 'www'
            src: '**/*'
        stage:
            options:
                base: 'www'
                repo: 'git@github.com:dominiclooser/dominiclooser.ch-stage.git'
            src: '**/*'

    postcss:
        options:
            processors:
                autoprefixer
                    browers: 'last 2 versions'
        dist:
            src: 'www/styles/styles.css'

    copy:
        main:
            src: []
            expand: true
            dest: 'www/'
        
    stylus:
        main:
            src: 'styles/styles.styl'
            dest: 'www/styles/styles.css'
    yaml:
        main:
            expand: true
            src: '_*.yml'
            ext: '.json'
    watch:
        options:
            livereload: true
        yaml:
            files: ['**/*.yml']
            tasks: ['yaml']
        stylus:
            files:['**/*.styl']
            tasks: ['stylus']
        all:
            files: ['**/*.*']
            tasks: []

module.exports = (grunt) ->
    grunt.initConfig config
    time grunt
    jit grunt
    grunt.registerTask 'default', ['yaml', 'watch']
    grunt.registerTask 'compile', ['yaml','force:on', 'exec:harp','force:off', 'copy', 'stylus', 'postcss']
    grunt.registerTask 'deploy', ['exec:harp', 'gh-pages:production']
    grunt.registerTask 'stage', ['compile', 'gh-pages:stage']
