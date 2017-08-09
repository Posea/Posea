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

import { config, database } from "./main"
import { sendMail } from "./mail"
import { LANG } from "./lang"
import { log } from "./log"
import * as crypto from 'crypto'

# Collection for revoking authentication tokens
cAuth = null
# TODO: Collection for blacklisting users

export authRoutes = (app) ->
  app.get '/auth/login', auth_login
  app.get '/auth/confirm', auth_confirm
  cAuth = database.collection('auth')

auth_login = (req, res) ->
  # TODO: Rate limit - Do not allow a user to authenticate twice within auth_timeout
  # TODO: Rate limit - IP based.
  # TODO: Blacklisting - Disallow specific users from trying to login or comment. (Revokes the logged-in state)
  # TODO: Validate e-mail address first
  if !req.query.email?
    res.sendStatus 406
  else
    [token, time] = await authorize req.query.email
    url = config.base_url + "/auth/confirm?email=#{req.query.email}&time=#{time}&token=#{token}"
    try
      await sendMail(
        req.query.email,
        LANG.str['auth_email_title'].replace('{{title}}', config.site_title),
        LANG.str['auth_email_content']
          .replace(/\{\{title\}\}/g, config.site_title)
          .replace(/\{\{base_url\}\}/g, config.base_url)
          .replace(/\{\{url\}\}/g, url)
      )
      res.send JSON.stringify ok: true
    catch e
      res.sendStatus 406

auth_confirm = (req, res) ->
  if !req.query.token? || !req.query.email? || !req.query.time?
    res.sendStatus 406
  else
    c = await confirm_authorization req.query.token, req.query.time, req.query.email
    if !c?
      res.sendStatus 403
    else
      [token, time] = c
      res.cookie 'POSEA-USER-EMAIL', req.query.email
      res.cookie 'POSEA-USER-TOKEN', token
      res.cookie 'POSEA-USER-TIME', time
      res.redirect 302, config.base_url

export hmac = (data, secret) -> new Promise (resolve, reject) =>
  h = crypto.createHmac 'sha256', secret
  h.on 'readable', () =>
    data = h.read()
    if data
      resolve data.toString 'hex'
  h.write data
  h.end()

# Called when a user tries to comment for the first time
# A token for authentication will be generated and later sent to the user's mailbox
# Must be confirmed within conifg.auth_timeout
# @return: [token, timestamp]
export authorize = (email) ->
  obj =
    type: 'auth'
    time: new Date().getTime()
    email: email
  token = await hmac JSON.stringify(obj), config.secret
  return [token, obj.time]

# Called when a user clicks on the confirmation link in the mailbox
# Checks whether auth_token is valid and signs a new token to tag the user as logged in.
# @return:
#   null if authentication failed
#   [token, timestamp] if succeeded
export confirm_authorization = (auth_token, time, email) ->
  try
    # Check if this token has been used or revoked
    result = await cAuth.findOne { token: auth_token }
    return null if result isnt null
  catch error
    # Never mind (might be in Mocha test)
    # TODO: Make this work in Mocha tests
    log.verbose error
  auth_obj =
    type: 'auth'
    time: Number.parseInt time
    email: email
  if auth_token isnt await hmac(JSON.stringify(auth_obj), config.secret)
    return null
  if time + config.auth_timeout * 1000 < new Date().getTime()
    return null
  obj =
    type: 'login'
    time: new Date().getTime()
    email: email
  token = await hmac JSON.stringify(obj), config.secret
  try
    # Revoke this authorization token before distributing the login token
    await cAuth.insertOne { token: auth_token }
  catch error
    # Never mind (might be in Mocha test)
    log.verbose error
  return [token, obj.time]

# Check if a token is valid with regard to a timestamp and an e-mail address
# TODO: Token revocation. Might be done through a simple blacklist.
# @return: boolean
export check_token = (token, time, email) ->
  obj =
    type: 'login'
    time: time
    email: email
  token == await hmac JSON.stringify(obj), config.secret
