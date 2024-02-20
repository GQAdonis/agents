# syntax=docker/dockerfile:1

ARG PYTHON_VERSION=3.11.6
FROM python:${PYTHON_VERSION}-bookworm as base

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# RUN apt-get update
# RUN apt-get install -y git gcc build-essential

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the source code into the container.
COPY . .

RUN mkdir -p /usr/local/src/ && cd /usr/local/src &&  git clone http://github.com/livekit/agents.git
RUN mv /usr/local/src/agents/livekit-agents /app
RUN cd /app/livekit-agents && python setup.py install

RUN mv /usr/local/src/agents/livekit-plugins /app
RUN cd /app/livekit-plugins/livekit-plugins-deepgram && python setup.py install
RUN cd /app/livekit-plugins/livekit-plugins-elevenlabs && python setup.py install

# Switch to the non-privileged user to run the application.
USER appuser

# Run the application.
CMD python kitt.py start
