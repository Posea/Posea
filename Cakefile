{exec} = require 'child_process'

execLive = (cmd, callback) ->
  exec cmd, callback
    .stdout.pipe process.stdout

task 'build', 'Build the project', ->
  execLive 'node_modules/.bin/coffee -o mid -c src && node_modules/.bin/babel --presets env -d lib mid && rm -rf mid', (err) =>
    throw new err if err
