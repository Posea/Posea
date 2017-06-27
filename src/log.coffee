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

import * as winston from 'winston'
import { env } from './main'

export log = null
export logInit = ->
  level = if env is 'test' then 'verbose' else 'info'
  log = new winston.Logger
    transports: [
      new winston.transports.Console
        level: level
    ]
  return level
