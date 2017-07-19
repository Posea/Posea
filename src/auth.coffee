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

import { config } from "./main"
import * as crypto from 'crypto'

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
  auth_obj =
    type: 'auth'
    time: time
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
