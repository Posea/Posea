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

token = (email) -> hmac email, config.secret
