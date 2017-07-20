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

import { config } from '../main'
import { LANG } from '../lang'

# English (United States)
if config.lang == 'en_US'
  LANG.str =
    'hello': 'Hello, world.'
    'auth_email_title': '{{title}} login confirmation'

  LANG.str['auth_email_content'] = '''
Hello,
<br/><br/>
You are receiving this e-mail because you tried to use this e-mail address to comment on {{title}}. Please click on the following link to confirm this action:
<br/><br/>
<a href='{{url}}'>{{url}}</a>
<br/><br/>
If it does not show as a link, please copy and paste it to the address bar manually.
<br/><br/>
If you know nothing about this request, please ignore this e-mail. If you keep receiving these e-mails, please contact the administrators at {{base_url}}.
<br/><br/>
Regards.
'''
