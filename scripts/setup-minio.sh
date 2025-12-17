#!/bin/bash

echo "======================================"
echo "  MinIO Bucket Setup"
echo "======================================"
echo ""

# Wait for MinIO to be ready
echo "⏳ Waiting for MinIO to be ready..."
sleep 5

echo "� Creating buckets..."

# Create all buckets in a single container run with proper shell
docker run --rm --network mini-datalake-stack_datalake-network \
  --entrypoint /bin/sh \
  minio/mc:latest \
  -c "
    mc alias set myminio http://minio:9000 minioadmin minioadmin123 && \
    mc mb myminio/raw --ignore-existing && \
    mc mb myminio/bronze --ignore-existing && \
    mc mb myminio/silver --ignore-existing && \
    mc mb myminio/gold --ignore-existing && \
    echo '' && \
    echo '📋 Buckets created:' && \
    mc ls myminio
  "

echo ""
echo "✅ MinIO setup complete!"
echo ""
echo "💡 Access MinIO Console at: http://localhost:9001"
echo "   User: minioadmin / Password: minioadmin123"
echo ""
