FROM python:3.12-slim

# Set work directory
WORKDIR /app

# Install system dependencies (for psycopg2, etc.)
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Expose the SMTP port (Standard is 25, but we might run on 8025 internally)
EXPOSE 1025

# Run the application
CMD ["python", "main.py"]
