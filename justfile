# Variables
REMOTE_USER := "root"
REMOTE_HOST := "138.197.56.84"
REMOTE_PATH := "/var/www/bossadapt.org"

compress-project:
    zip -r project.zip . -x "*.git*" "*.DS_Store" "*.log" "*.tmp" "*.zip"

scp-project:
    scp project.zip {{REMOTE_USER}}@{{REMOTE_HOST}}:{{REMOTE_PATH}}

clean:
    rm -f project.zip

run:
    docker-compose -f docker-compose.yml up -d
    ssh {{REMOTE_USER}}@{{REMOTE_HOST}} "cd {{REMOTE_PATH}} && unzip project.zip && docker-compose up --build -d && rm project.zip && docker system prune -f"
deploy: compress-project scp-project clean run
