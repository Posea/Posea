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

import { config } from './main'
import * as nodemailer from 'nodemailer'
import striptags from 'striptags'

transport = null

export mailInit = ->
  transport = nodemailer.createTransport
    host: config.smtp.host
    port: config.smtp.port
    secure: config.smtp.secure
    auth:
      user: config.smtp.auth.user
      pass: config.smtp.auth.pass

export sendMail = (addr, title, content) ->
  opt =
    from: "\"#{config.smtp.from_name}\" <#{config.smtp.from}>"
    to: addr
    subject: title
    text: striptags content
    html: content
  new Promise (resolve, reject) ->
    transport.sendMail opt, (error, info) ->
      if error?
        reject error
      resolve info
