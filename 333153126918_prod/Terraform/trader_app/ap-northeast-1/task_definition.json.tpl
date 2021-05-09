 [
    {
      "dnsSearchDomains": null,
      "environmentFiles": null,
      "logConfiguration": null,
      "entryPoint": null,
      "portMappings": [],
      "command": null,
      "linuxParameters": null,
      "cpu": 2,
      "environment": [],
      "resourceRequirements": null,
      "ulimits": null,
      "dnsServers": null,
      "mountPoints": [],
      "workingDirectory": null,
      "secrets": [
        {
          "name": "telegramApiHash",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/telegramApiHash"
        },
        {
          "name": "telegramPhone",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/telegramPhone"
        },
        {
          "name": "discordBotToken",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/discordBotToken"
        },
        {
          "name": "discordArielleToken",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/discordArielleToken"
        },
        {
          "name": "discordBeepToken",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/discordBeepToken"
        },
        {
          "name": "discordGraceToken",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/discordGraceToken"
        },
        {
          "name": "discordLexingtonToken",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/discordLexingtonToken"
        },
        {
          "name": "discordMscToken",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/discordMscToken"
        },
        {
          "name": "urlShortenerToken",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/urlShortenerToken"
        },
        {
          "name": "telegramReaderToken",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/telegramReaderToken"
        },
        {
          "name": "binanceApiKey",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/binanceApiKey"
        },   
        {
          "name": "binanceSecretKey",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/binanceSecretKey"
        }, 
        {
          "name": "kucoinApiKey",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/kucoinApiKey"
        }, 
        {
          "name": "kucoinSecretKey",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/kucoinSecretKey"
        }, 
        {
          "name": "kucoinPassphrase",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/kucoinPassphrase"
        },     
        {
          "name": "cmcApiKey",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/cmcApiKey"
        },    
        {
          "name": "twilioAccountSid",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/twilioAccountSid"
        },    
        {
          "name": "twilioAuthorizationToken",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/twilioAuthorizationToken"
        },    
        {
          "name": "robotAccountSid",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/robotAccountSid"
        },    
        {
          "name": "robotAccountAuthToken",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/robotAccountAuthToken"
        },    
        {
          "name": "robotFromPhonenumber1",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/robotFromPhonenumber1"
        },         
        {
          "name": "robotToPhoneNumber1",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/robotToPhoneNumber1"
        },       
        {
          "name": "robotFromPhoneNumber2",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/robotFromPhoneNumber2"
        },       
        {
          "name": "robotToPhoneNumber2",
          "valueFrom": "arn:aws:ssm:ap-northeast-1:333153126918:parameter/robotToPhoneNumber2"
        }                                                                                                                                                                                                 
      ],
      "dockerSecurityOptions": null,
      "memory": 4096,
      "memoryReservation": null,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "333153126918.dkr.ecr.ap-northeast-1.amazonaws.com/worker:latest",
      "startTimeout": null,
      "firelensConfiguration": null,
      "dependsOn": null,
      "disableNetworking": null,
      "interactive": null,
      "healthCheck": null,
      "essential": true,
      "links": null,
      "hostname": null,
      "extraHosts": null,
      "pseudoTerminal": null,
      "user": null,
      "readonlyRootFilesystem": null,
      "dockerLabels": null,
      "systemControls": null,
      "privileged": null,
      "name": "worker"
    }
  ]
  