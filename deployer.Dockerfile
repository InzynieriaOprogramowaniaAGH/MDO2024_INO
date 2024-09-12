FROM python:3.9-slim

COPY --from=flask-build /MDO2024_INO/ITE/GCL4/DP411750/app.py app.py

RUN pip install flask

EXPOSE 5001

CMD ["python", "app.py"]
