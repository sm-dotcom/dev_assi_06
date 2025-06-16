# Use official Python image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy requirements from the subfolder
COPY myapp/requirement.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirement.txt

# Copy rest of the application
COPY myapp/ .

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Run your app
CMD ["python", "hello.py"]
