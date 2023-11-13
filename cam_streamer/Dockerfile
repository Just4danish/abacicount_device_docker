FROM python:3.10

RUN pip install --upgrade pip && \
    apt-get update && \
    apt-get install -y git openssh-client libgl1-mesa-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Configure SSH for Git
RUN mkdir /root/.ssh && \
    echo "StrictHostKeyChecking no" > /root/.ssh/config

# Copy the SSH deploy key
COPY deploy_key /root/.ssh/deploy_key

# Correct permissions for the deploy key
RUN chmod 600 /root/.ssh/deploy_key

# Set the working directory
WORKDIR /app

# Clone the specific branch of the private repository
RUN GIT_SSH_COMMAND='ssh -i /root/.ssh/deploy_key' git clone -b latest_version git@github.com:Just4danish/abacicount_new.git 

# Copy contents from the cloned repository and remove the cloned directory
RUN cp -r abacicount_new/cam_streamer/* . && \
    rm -rf abacicount_new

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt 
ENTRYPOINT ["sh", "entrypoint.sh"]
