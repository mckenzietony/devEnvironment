{
    "networkMode": "awsvpc",
    "containerDefinitions": [
        {
            "name": "worker",
            "image": "${REPOSITORY_URL}:latest",
            "essential": true,
            "entryPoint": [""],
            "command": [""],
            "environment": [
                {
                    "name": "testKey",
                    "value": "testValue"
                }
            ],
        }
    ]
}