time = require 'time-grunt'
jit = require 'jit-grunt'
autoprefixer = require 'autoprefixer'
cssVariables = require 'postcss-css-variables'
calc = require 'postcss-calc'

config =
    postcss:
        options:
            processors: [autoprefixer({browers: 'last 2 versions'}), cssVariables, calc]
        dist:
            src: 'www/styles/styles.css'
    'gh-pages':
        production:
            options:
                base: 'www'
            src: '**/*'
        stage:
            options:
                base: 'www'
                repo: 'git@github.com:dominiclooser/stage.diekrassetasse.com.git'
            src: '**/*'
    copy:
        'production-cname':
            src: '_cname/production'
            dest: 'www/CNAME'
        'stage-cname':
            src: '_cname/stage'
            dest: 'www/CNAME'
    yaml:
        main:
            expand: true
            src: '_*.yml'
            ext: '.json'
    exec: 
        harp: 'harp compile'
    stylus:
        main:
            src: 'styles/styles.styl'
            dest: 'www/styles/styles.css'
    watch:
        options:
            livereload: true
        yaml:
            files: ['**/*.yml']
            tasks: ['yaml']
        all:
            files: ['**/*.*']
            tasks: []

module.exports = (grunt) ->
    grunt.initConfig(config)
    time(grunt)
    jit(grunt)
    grunt.registerTask 'default', ['yaml', 'watch']
    grunt.registerTask 'compile', ['yaml', 'exec:harp', 'postcss']
    grunt.registerTask 'production', ['compile','copy:production-cname', 'gh-pages:production']
    grunt.registerTask 'stage', ['compile', 'copy:stage-cname', 'gh-pages:stage']
