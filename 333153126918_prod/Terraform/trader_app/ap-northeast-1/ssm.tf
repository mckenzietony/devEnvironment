resource "aws_ssm_parameter" "telegram_api_hash" {
  name        = "telegramApiHash"
  description = "Telegram API Hash"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "telegram_phone" {
  name        = "telegramPhone"
  description = "Telegram phone"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "discord_bot_token" {
  name        = "discordBotToken"
  description = "discord bot token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "discord_arielle_token" {
  name        = "discordArielleToken"
  description = "discord arielle token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "discord_beep_token" {
  name        = "discordBeepToken"
  description = "discord beep token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "discord_grace_token" {
  name        = "discordGraceToken"
  description = "discord grace token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "discord_lexington_token" {
  name        = "discordLexingtonToken"
  description = "discord lexington token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "discord_msc_token" {
  name        = "discordMscToken"
  description = "discord msc token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "bitly_token" {
  name        = "urlShortenerToken"
  description = "parse url bitly token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "telegram_reader_token" {
  name        = "telegramReaderToken"
  description = "telegram reader token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "binance_api_key" {
  name        = "binanceApiKey"
  description = "binance api key"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "binance_secret_key" {
  name        = "binanceSecretKey"
  description = "binance secret key"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "kucoin_api_key" {
  name        = "kucoinApiKey"
  description = "kucoin api key"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "kucoin_secret_key" {
  name        = "kucoinSecretKey"
  description = "kucoin secret key"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "kucoin_passphrase" {
  name        = "kucoinPassphrase"
  description = "kucoin passphrae"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}
resource "aws_ssm_parameter" "cmc_data_api_key" {
  name        = "cmcApiKey"
  description = "market cmc data api key"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "twilio_account_sid" {
  name        = "twilioAccountSid"
  description = "twilio account sid"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}
resource "aws_ssm_parameter" "twilio_auth_token" {
  name        = "twilioAuthorizationToken"
  description = "twilio authorization token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}
resource "aws_ssm_parameter" "robot_account_sid" {
  name        = "robotAccountSid"
  description = "global robot account sid"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "robot_account_auth_token" {
  name        = "robotAccountAuthToken"
  description = "robot account auth token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "robot_from_phonenumber_1" {
  name        = "robotFromPhonenumber1"
  description = "robot from phonenumber 1"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "robot_to_phonenumber_1" {
  name        = "robotToPhoneNumber1"
  description = "robot to phonenumber 1"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "robot_from_phonenumber_2" {
  name        = "robotFromPhoneNumber2"
  description = "robot from phonenumber 2"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "robot_to_phonenumber_2" {
  name        = "robotToPhoneNumber2"
  description = "robot to phonenumber 2"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}