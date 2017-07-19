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
import { hmac } from '../lib/auth'
import assert from 'assert'

describe 'Auth', ->
  it 'HMAC test suite 1', ->
    assert (await hmac('some data to hash', 'a secret')) is '7fd04df92f636fd450bc841c9418e5825c17f33ad9c87c518115a45971f7f77e'
  it 'HMAC test suite 2', ->
    assert (await hmac('v45m9iv4n9reoknivcwoepvpq,cp[qmcqovnreiobeuheiobn0095n49054mnm40n-605-990n344opb3mb3', 'erbtrbntrenytenytm63njm564m87641456')) is '55fb2ac65450dda81182d406ea6a20e388b0387b643226b9e4f880a4f2d8cdf3'
  it 'HMAC test suite 3', ->
    assert (await hmac('A quick brown fox jumps over a lazy dog', '32f34grebvr3h5hn5k86')) is '416bfbff551a602bf194a269217fee0d77637fd57235dd8b75098835e34bebec'
