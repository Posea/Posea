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
if config.lang == 'zh_CN'
  LANG.str =
    'hello': '你好，世界。'
    'auth_email_title': '{{title}} 登录确认'

  LANG.str['auth_email_content'] = '''
您好，
<br/><br/>
您正在尝试使用这个邮箱登录 {{title}} 的评论系统。请点击以下链接来确认:
<br/><br/>
<a href='{{url}}'>{{url}}</a>
<br/><br/>
如果上面的链接不可点击，请手动复制到浏览器地址栏。
<br/><br/>
如果您对本邮件提及的内容毫不知情，请忽略本邮件；如果您一直收到这样的邮件并认为受到打扰，请联系 {{base_url}} 的管理员。
<br/><br/>
谢谢。
'''
