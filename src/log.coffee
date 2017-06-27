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
