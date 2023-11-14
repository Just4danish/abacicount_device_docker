# Use an official Python runtime as a parent image
FROM python:3.10

# Upgrade pip and install required packages
RUN apt-get update && \
    apt-get install -y git openssh-client libgl1-mesa-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Upgrade pip
RUN pip install --upgrade pip

# Configure SSH for Git
RUN mkdir -p /root/.ssh && \
    echo "StrictHostKeyChecking no" > /root/.ssh/config

# Copy the SSH deploy key and set the correct permissions
COPY cam_streamer/deploy_key /root/.ssh/deploy_key
RUN chmod 600 /root/.ssh/deploy_key

# Set the working directory
WORKDIR /app

# Clone the private repository's latest_version into the working directory (/app)
RUN GIT_SSH_COMMAND='ssh -i /root/.ssh/deploy_key' git clone -b latest_version git@github.com:Just4danish/abacicount_new.git .

# Copy the requirements file and install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entrypoint script and ensure it's executable
RUN chmod +x entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["sh", "entrypoint.sh"]
