# example grpc server
FROM python

RUN pip install grpcio grpcio-reflection

WORKDIR /app
COPY . /app

EXPOSE 50051

CMD ["python", "grpc_server_with_reflection.py"]


