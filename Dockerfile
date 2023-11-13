# Use an official Python runtime as a parent image
FROM python:3.10

# Upgrade pip and install required packages
RUN pip install --upgrade pip && \
    apt-get update && \
    apt-get install -y git openssh-client libgl1-mesa-dev && \
    apt-get install -y docker.io && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Configure SSH for Git
RUN echo "StrictHostKeyChecking no" > /root/.ssh/config

# Copy the SSH deploy key and set the correct permissions
COPY cam_streamer/deploy_key /root/.ssh/deploy_key
RUN chmod 600 /root/.ssh/deploy_key

# Set the working directory
WORKDIR /app

# Clone the private repository's latest_version into the working directory (/app)
RUN GIT_SSH_COMMAND='ssh -i /root/.ssh/deploy_key' git clone -b latest_version git@github.com:Just4danish/abacicount_new.git .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt 

# Entrypoint script and set permissions
ENTRYPOINT ["sh", "entrypoint.sh"]
