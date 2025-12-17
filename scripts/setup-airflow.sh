#!/bin/bash

echo "======================================"
echo "  Airflow Configuration Setup"
echo "======================================"
echo ""

# Wait for Airflow to be ready
echo "⏳ Waiting for Airflow to be ready..."
sleep 10

echo "🔧 Installing Airflow Providers..."

# Install useful Airflow providers
docker exec -u airflow airflow-webserver pip install --quiet --user \
  apache-airflow-providers-apache-spark \
  apache-airflow-providers-amazon \
  apache-airflow-providers-postgres 2>/dev/null || \
  echo "   ⚠️  Some providers may already be installed"

echo ""
echo "✅ Airflow providers configured:"
echo "   - apache-spark (for Spark integration)"
echo "   - amazon (for S3/MinIO integration)"
echo "   - postgres (for database operations)"

echo ""
echo "📋 Verifying Airflow installation..."
docker exec airflow-webserver airflow version

echo ""
echo "👤 Airflow admin user:"
echo "   Username: admin"
echo "   Password: admin"

echo ""
echo "🔗 Creating MinIO connection in Airflow..."
docker exec airflow-webserver airflow connections add 'minio_conn' \
  --conn-type 'aws' \
  --conn-login 'minioadmin' \
  --conn-password 'minioadmin123' \
  --conn-extra '{"endpoint_url": "http://minio:9000", "aws_access_key_id": "minioadmin", "aws_secret_access_key": "minioadmin123"}' \
  2>/dev/null || echo "   Connection 'minio_conn' already exists"

echo ""
echo "🔗 Creating Spark connection in Airflow..."
docker exec airflow-webserver airflow connections add 'spark_default' \
  --conn-type 'spark' \
  --conn-host 'spark://spark-master' \
  --conn-port '7077' \
  2>/dev/null || echo "   Connection 'spark_default' already exists"

echo ""
echo "📊 Listing DAGs..."
docker exec airflow-webserver airflow dags list

echo ""
echo "✅ Airflow setup complete!"
echo ""
echo "💡 Access Airflow UI at: http://localhost:8081"
echo "   User: admin / Password: admin"
echo ""
