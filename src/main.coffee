import * as express from 'express'

# Load configuration
env = process.env.NODE_ENV
if !env? or env.trim() is ''
  env = 'test'
export config = require "../config.#{env}.json"

main = ->
  console.log 'hello world'
main null
