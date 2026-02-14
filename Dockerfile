# Use Python 3.12 Alpine
FROM python:3.12-alpine3.20

WORKDIR /app

COPY . .

# Install system dependencies
RUN apk add --no-cache \
    gcc \
    libffi-dev \
    musl-dev \
    ffmpeg \
    aria2 \
    make \
    g++ \
    cmake \
    wget \
    unzip

# Install Bento4
RUN wget -q https://github.com/axiomatic-systems/Bento4/archive/v1.6.0-639.zip && \
    unzip v1.6.0-639.zip && \
    cd Bento4-1.6.0-639 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    cp mp4decrypt /usr/local/bin/ && \
    cd ../.. && \
    rm -rf Bento4-1.6.0-639 v1.6.0-639.zip

# 🔥 IMPORTANT FIX HERE
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Install Python dependencies
RUN pip install --no-cache-dir -r sainibots.txt
RUN pip install --no-cache-dir yt-dlp

CMD ["sh", "-c", "gunicorn app:app & python3 modules/main.py"]
