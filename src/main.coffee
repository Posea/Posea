###
  This file is part of Posea.

  Posea is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Posea is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.

  You should have received a copy of the GNU Affero General Public License
  along with Posea.  If not, see <http://www.gnu.org/licenses/>.
###

import 'babel-polyfill'
import express from 'express'
import { MongoClient } from 'mongodb'
import { log, logInit } from './log'
import { langInit, LANG } from './lang'
import { mailInit } from './mail'
import { authRoutes } from './auth'

# Load configuration
export env = process.env.NODE_ENV
if !env? or env.trim() is ''
  env = 'test'
export config = require "../config.#{env}.json"
export database = null
export app = null

level = logInit null
log.verbose "Logging level set to #{level}"

langInit null
mailInit null

main = ->
  log.info LANG.str['hello']
  dbUrl = "mongodb://#{config.mongo.server}:#{config.mongo.port}/#{config.mongo.db}"
  log.info "Connecting to #{dbUrl}"
  MongoClient.connect dbUrl, (err, db) =>
    throw err if err
    log.info "MongoDB connection established."
    database = db
    app = express()
    authRoutes app
    app.listen config.http.port, =>
      log.info "Listening on http://127.0.0.1:#{config.http.port}"

export setDB = (db) -> database = db

if typeof global.it isnt 'function'
  # Not in Mocha
  main null
