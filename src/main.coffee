import express from 'express'
import { MongoClient } from 'mongodb'
import { log, logInit } from './log'

# Load configuration
export env = process.env.NODE_ENV
if !env? or env.trim() is ''
  env = 'test'
export config = require "../config.#{env}.json"
export database = null
export app = null

level = logInit null
log.verbose "Logging level set to #{level}"

main = ->
  dbUrl = "mongodb://#{config.mongo.server}:#{config.mongo.port}/#{config.mongo.db}"
  log.info "Connecting to #{dbUrl}"
  MongoClient.connect dbUrl, (err, db) =>
    throw err if err
    log.info "MongoDB connection established."
    databse = db
    app = express()
    # TODO: Setup routes
    app.listen config.http.port, =>
      log.info "Listening on http://127.0.0.1:#{config.http.port}"

main null
