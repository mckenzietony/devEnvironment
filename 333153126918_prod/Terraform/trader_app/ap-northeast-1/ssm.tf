resource "aws_ssm_parameter" "telegram_api_hash" {
  name        = "telegram_api_hash"
  description = "Telegram API Hash"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "telegram_phone" {
  name        = "telegram_phone"
  description = "Telegram phone"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "discord_bot_token" {
  name        = "discord_bot_token"
  description = "discord bot token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "discord_arielle_token" {
  name        = "discord_arielle_token"
  description = "discord arielle token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "discord_beep_token" {
  name        = "discord_beep_token"
  description = "discord beep token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "discord_grace_token" {
  name        = "discord_grace_token"
  description = "discord grace token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "discord_lexington_token" {
  name        = "discord_lexington_token"
  description = "discord lexington token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "discord_msc_token" {
  name        = "discord_msc_token"
  description = "discord msc token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "bitly_token" {
  name        = "bitly_token"
  description = "parse url bitly token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "telegram_reader_token" {
  name        = "telegram_reader_token"
  description = "telegram reader token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "binance_api_key" {
  name        = "binance_api_key"
  description = "binance api key"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "binance_secret_key" {
  name        = "binance_secret_key"
  description = "binance secret key"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "kucoin_api_key" {
  name        = "kucoin_api_key"
  description = "kucoin api key"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "kucoin_secret_key" {
  name        = "kucoin_secret_key"
  description = "kucoin secret key"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "cmc_data_api_key" {
  name        = "cmc_data_api_key"
  description = "market cmc data api key"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "robot_account_sid" {
  name        = "robot_account_sid"
  description = "global robot account sid"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "robot_account_auth_token" {
  name        = "robot_account_auth_token"
  description = "robot account auth token"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "robot_from_phonenumber_1" {
  name        = "robot_from_phonenumber_1"
  description = "robot from phonenumber 1"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "robot_to_phonenumber_1" {
  name        = "robot_to_phonenumber_1"
  description = "robot to phonenumber 1"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "robot_from_phonenumber_2" {
  name        = "robot_from_phonenumber_2"
  description = "robot from phonenumber 2"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "robot_to_phonenumber_2" {
  name        = "robot_to_phonenumber_2"
  description = "robot to phonenumber 2"
  type        = "SecureString"
  value       = "FillMeUp"
  overwrite   = false

  tags = {
    environment = "production"
  }
}