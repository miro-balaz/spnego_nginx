FROM ubuntu:latest
# Flask    
RUN apt-get update && apt-get install -y \
        python3 \
        python3-pip
COPY ./src/requirements.txt .
RUN pip3 install  --no-cache-dir -r requirements.txt

EXPOSE 5000