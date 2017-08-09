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
import * as main from '../lib/main'
import { MongoClient } from 'mongodb'
import { hmac, authorize, confirm_authorization, check_token, initAuth } from '../lib/auth'
import assert from 'assert'

# For testing
# WARNING: DO NOT RUN IN PRODUCTION
# NEEDS MongoDB on 127.0.0.1:27017
connectMongo = ->
  new Promise (resolve, reject) =>
    MongoClient.connect 'mongodb://127.0.0.1:27017/posea_test_auth', (err, db) ->
      if err?
        reject err
      else
        resolve db

initDB = ->
  if main.database is null
    main.setDB await connectMongo()

describe 'Auth', ->
  before ->
    await initDB()
    initAuth()
  after ->
    await main.database.dropDatabase()
  it 'HMAC test suite 1', ->
    assert (await hmac('some data to hash', 'a secret')) is '7fd04df92f636fd450bc841c9418e5825c17f33ad9c87c518115a45971f7f77e'
  it 'HMAC test suite 2', ->
    assert (await hmac('v45m9iv4n9reoknivcwoepvpq,cp[qmcqovnreiobeuheiobn0095n49054mnm40n-605-990n344opb3mb3', 'erbtrbntrenytenytm63njm564m87641456')) is '55fb2ac65450dda81182d406ea6a20e388b0387b643226b9e4f880a4f2d8cdf3'
  it 'HMAC test suite 3', ->
    assert (await hmac('A quick brown fox jumps over a lazy dog', '32f34grebvr3h5hn5k86')) is '416bfbff551a602bf194a269217fee0d77637fd57235dd8b75098835e34bebec'
  it 'Authorization algorithm test suite 1', ->
    [token, time] = await authorize 'test@domain.com'
    assert (await confirm_authorization token, time, 'test@domain.com') isnt null
  it 'Authorization algorithm test suite 2', ->
    [token, time] = await authorize 'test@domain.com'
    assert (await confirm_authorization token, time + 1000, 'test@domain.com') is null
  it 'Authorization algorithm test suite 3', ->
    [token, time] = await authorize 'test@domain.com'
    assert (await confirm_authorization token, time, 'test1@domain.com') is null
  it 'Authorization algorithm test suite 4', ->
    [auth, time] = await authorize 'test@domain.com'
    [token, time] = await confirm_authorization auth, time, 'test@domain.com'
    assert (await check_token token, time, 'test@domain.com') is true
  it 'Authorization algorithm test suite 5', ->
    [auth, time] = await authorize 'test@domain.com'
    [token, time] = await confirm_authorization auth, time, 'test@domain.com'
    assert (await check_token token, time, 'test1@domain.com') is false
  it 'Authorization algorithm test suite 6', ->
    [auth, time] = await authorize 'test@domain.com'
    [token, time] = await confirm_authorization auth, time, 'test@domain.com'
    assert (await check_token token, time - 1, 'test@domain.com') is false
  it 'Should not allow one to login twice', ->
    [auth, time] = await authorize 'test@domain.com'
    [token, time] = await confirm_authorization auth, time, 'test@domain.com'
    assert (await confirm_authorization auth, time, 'test@domain.com') is null
